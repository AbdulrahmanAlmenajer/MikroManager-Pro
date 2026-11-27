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

  Stream<List<VoucherBatchesTableData>> watchBatches({String? systemType}) {
    final query = _db.select(_db.voucherBatchesTable);
    if (systemType != null && systemType.isNotEmpty) {
      query.where((t) => t.systemType.equals(systemType));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.generatedAt, mode: OrderingMode.desc)
    ]);
    return query.watch();
  }

  Future<List<VoucherBatchesTableData>> getBatches({String? systemType}) async {
    final query = _db.select(_db.voucherBatchesTable);
    if (systemType != null && systemType.isNotEmpty) {
      query.where((t) => t.systemType.equals(systemType));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.generatedAt, mode: OrderingMode.desc)
    ]);
    return await query.get();
  }

  Future<int?> getLastSerialEnd(int routerId) async {
    final query = _db.select(_db.voucherBatchesTable)
      ..where((t) => t.routerId.equals(routerId))
      ..where((t) => t.serialEnd.isNotNull())
      ..orderBy([
        (t) => OrderingTerm(expression: t.serialEnd, mode: OrderingMode.desc)
      ])
      ..limit(1);
    final batch = await query.getSingleOrNull();
    return batch?.serialEnd;
  }

  Future<int> saveBatch({
    required int routerId,
    required String profileName,
    required int quantity,
    required String prefix,
    required int codeLength,
    required List<VoucherCardData> vouchers,
    required double unitPrice,
    String systemType = 'hotspot',
    String? serialPrefix,
    int? serialStart,
    int? serialPadding,
    int? serialEnd,
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
            systemType: Value(systemType),
            serialPrefix: Value(serialPrefix),
            serialStart: Value(serialStart),
            serialPadding: Value(serialPadding),
            serialEnd: Value(serialEnd),
            notes: Value(notes),
            generatedAt: Value(DateTime.now()),
          ),
        );

    await _auditLogger.log(
      action: 'generate',
      entityType: 'voucher_batch',
      entityId: id.toString(),
      description:
          'توليد دفعة كروت جديدة (#$id - $systemType): $quantity كرت لبروفايل $profileName بإجمالي $totalAmount',
    );

    return id;
  }

  Future<bool> deleteBatch(int id) async {
    final deleted = await (_db.delete(_db.voucherBatchesTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
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

  /// Upload batch directly to router in batches of 50 with progress and serial comments
  Future<int> uploadToRouter({
    required RouterOsAdapter adapter,
    required List<VoucherCardData> vouchers,
    required bool isUserManager,
    String batchTag = 'MikroManager-Batch',
    void Function(int current, int total)? onProgress,
    bool Function()? isCancelled,
  }) async {
    int successCount = 0;
    const chunkSize = 50;

    for (int i = 0; i < vouchers.length; i += chunkSize) {
      if (isCancelled != null && isCancelled()) break;
      final end =
          (i + chunkSize > vouchers.length) ? vouchers.length : i + chunkSize;
      final chunk = vouchers.sublist(i, end);

      for (final voucher in chunk) {
        if (isCancelled != null && isCancelled()) break;
        final serialTag = (voucher.serialNumber != null &&
                voucher.serialNumber!.isNotEmpty)
            ? '|SN:${voucher.serialNumber}'
            : '';
        final comment = '$batchTag$serialTag';

        bool ok;
        if (isUserManager) {
          ok = await adapter.addUserManagerUser(
            username: voucher.username,
            password: voucher.password,
            profile: voucher.profile,
            comment: comment,
          );
        } else {
          ok = await adapter.addHotspotUser(
            name: voucher.username,
            password: voucher.password,
            profile: voucher.profile,
            comment: comment,
          );
        }
        if (ok) successCount++;
      }

      onProgress?.call(
          successCount, vouchers.length);
    }

    return successCount;
  }

  /// Check whether any of the candidate usernames already exist on the router
  Future<List<String>> checkUsernameCollisions({
    required RouterOsAdapter adapter,
    required List<String> usernames,
    required bool isUserManager,
  }) async {
    final collisions = <String>[];
    try {
      if (isUserManager) {
        final existing = await adapter.getUserManagerUsers();
        final existingNames = existing
            .map((u) => (u['name'] ?? u['username'] ?? '').toString())
            .where((s) => s.isNotEmpty)
            .toSet();
        for (final u in usernames) {
          if (existingNames.contains(u)) collisions.add(u);
        }
      } else {
        final existing = await adapter.getHotspotUsers();
        final existingNames = existing
            .map((u) => (u['name'] ?? '').toString())
            .where((s) => s.isNotEmpty)
            .toSet();
        for (final u in usernames) {
          if (existingNames.contains(u)) collisions.add(u);
        }
      }
    } catch (_) {
      // If fetching full list fails or is unsupported, allow proceed
    }
    return collisions;
  }
}
