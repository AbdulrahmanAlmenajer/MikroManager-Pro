import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/routeros_adapter.dart';
import '../../../core/utils/audit_logger.dart';
import '../../../core/utils/pdf_generator_helper.dart';

class VouchersRepository {
  final AppDatabase _db;
  final AuditLogger _auditLogger;

  VouchersRepository(this._db, this._auditLogger);

  Stream<List<VoucherBatchesTableData>> watchBatches() {
    return (_db.select(_db.voucherBatchesTable)
          ..orderBy([(t) => OrderingTerm(expression: t.generatedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<List<VoucherBatchesTableData>> getBatches() async {
    return await (_db.select(_db.voucherBatchesTable)
          ..orderBy([(t) => OrderingTerm(expression: t.generatedAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> saveBatch({
    required int routerId,
    required String profileName,
    required int quantity,
    required String prefix,
    required int codeLength,
    required List<VoucherCardData> vouchers,
    required double unitPrice,
    String? notes,
  }) async {
    final vouchersJson = jsonEncode(vouchers.map((v) => v.toJson()).toList());
    final totalAmount = unitPrice * quantity;

    final id = await _db.into(_db.voucherBatchesTable).insert(
      VoucherBatchesTableCompanion.insert(
        routerId: routerId,
        profileName: profileName,
        quantity: quantity,
        prefix: Value(prefix),
        codeLength: Value(codeLength),
        vouchersJson: vouchersJson,
        unitPrice: Value(unitPrice),
        totalAmount: Value(totalAmount),
        notes: Value(notes),
        generatedAt: Value(DateTime.now()),
      ),
    );

    await _auditLogger.log(
      action: 'generate',
      entityType: 'voucher_batch',
      entityId: id.toString(),
      description: 'توليد دفعة كروت جديدة (#$id): $quantity كرت لبروفايل $profileName بإجمالي $totalAmount',
    );

    return id;
  }

  Future<bool> deleteBatch(int id) async {
    final deleted = await (_db.delete(_db.voucherBatchesTable)..where((tbl) => tbl.id.equals(id))).go();
    if (deleted > 0) {
      await _auditLogger.log(
        action: 'delete',
        entityType: 'voucher_batch',
        entityId: id.toString(),
        description: 'حذف دفعة الكروت (#$id)',
      );
    }
    return deleted > 0;
  }

  /// Upload batch directly to router in batches of 50 with progress
  Future<int> uploadToRouter({
    required RouterOsAdapter adapter,
    required List<VoucherCardData> vouchers,
    required bool isUserManager,
    void Function(int current, int total)? onProgress,
    bool Function()? isCancelled,
  }) async {
    int successCount = 0;
    const chunkSize = 50;

    for (int i = 0; i < vouchers.length; i += chunkSize) {
      if (isCancelled != null && isCancelled()) break;
      final end = (i + chunkSize > vouchers.length) ? vouchers.length : i + chunkSize;
      final chunk = vouchers.sublist(i, end);

      for (final voucher in chunk) {
        if (isCancelled != null && isCancelled()) break;
        bool ok;
        if (isUserManager) {
          ok = await adapter.addUserManagerUser(
            username: voucher.username,
            password: voucher.password,
            profile: voucher.profile,
            comment: 'MikroManager-Batch',
          );
        } else {
          ok = await adapter.addHotspotUser(
            name: voucher.username,
            password: voucher.password,
            profile: voucher.profile,
            comment: 'MikroManager-Batch',
          );
        }
        if (ok) successCount++;
      }
      onProgress?.call(successCount, vouchers.length);
    }
    return successCount;
  }
}
