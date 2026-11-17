import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/routeros_adapter.dart';

class BackupResult {
  final bool isSuccess;
  final String path;
  final String kind;
  final String? errorMessage;

  const BackupResult({
    required this.isSuccess,
    required this.path,
    required this.kind,
    this.errorMessage,
  });
}

class BackupRepository {
  final AppDatabase _db;

  BackupRepository(this._db);

  // =========================================================================
  // App Data Backup (JSON Export with SHA-256 Checksum)
  // =========================================================================

  Future<BackupResult> exportAppDataBackup(int connectionId) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory(p.join(docsDir.path, 'backups'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // 1. Gather all tables data
      final batches = await _db.select(_db.voucherBatchesTable).get();
      final templates = await _db.select(_db.voucherTemplatesTable).get();
      final profilePrices = await _db.select(_db.profilePricesTable).get();
      final payments = await _db.select(_db.paymentsTable).get();
      final aps = await _db.select(_db.apDevicesTable).get();
      final alertRules = await _db.select(_db.alertRulesTable).get();
      final quietHours = await _db.select(_db.quietHoursTable).get();

      final dataMap = {
        'version': 3.1,
        'exportedAt': DateTime.now().toIso8601String(),
        'connectionId': connectionId,
        'tables': {
          'voucher_batches': batches.map((b) => {
                'id': b.id,
                'routerId': b.routerId,
                'profileName': b.profileName,
                'quantity': b.quantity,
                'vouchersJson': b.vouchersJson,
                'unitPrice': b.unitPrice,
                'totalAmount': b.totalAmount,
                'generatedAt': b.generatedAt.toIso8601String(),
              }).toList(),
          'templates': templates.map((t) => {
                'id': t.id,
                'name': t.name,
                'headerText': t.headerText,
                'footerText': t.footerText,
                'showQrCode': t.showQrCode,
              }).toList(),
          'profile_prices': profilePrices.map((p) => {
                'connectionId': p.connectionId,
                'profileName': p.profileName,
                'price': p.price,
                'currency': p.currency,
              }).toList(),
          'payments': payments.map((pm) => {
                'connectionId': pm.connectionId,
                'amount': pm.amount,
                'note': pm.note,
                'receivedAt': pm.receivedAt.toIso8601String(),
              }).toList(),
          'ap_devices': aps.map((a) => {
                'connectionId': a.connectionId,
                'name': a.name,
                'ip': a.ip,
                'vendor': a.vendor,
              }).toList(),
          'alert_rules': alertRules.map((ar) => {
                'connectionId': ar.connectionId,
                'type': ar.type,
                'target': ar.target,
                'threshold': ar.threshold,
                'destination': ar.destination,
                'enabled': ar.enabled,
              }).toList(),
          'quiet_hours': quietHours.map((qh) => {
                'connectionId': qh.connectionId,
                'startMinute': qh.startMinute,
                'endMinute': qh.endMinute,
                'days': qh.days,
              }).toList(),
        },
      };

      final jsonString = jsonEncode(dataMap);
      final checksum = sha256.convert(utf8.encode(jsonString)).toString();

      final fullPayload = {
        'checksum': checksum,
        'data': dataMap,
      };

      final timestampStr = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final fileName = 'mmpro_app_backup_$timestampStr.json';
      final file = File(p.join(backupDir.path, fileName));
      await file.writeAsString(jsonEncode(fullPayload));

      // Record in backup_log
      await _logBackup(connectionId: connectionId, kind: 'app_data', path: file.path);

      return BackupResult(isSuccess: true, path: file.path, kind: 'app_data');
    } catch (e) {
      return BackupResult(isSuccess: false, path: '', kind: 'app_data', errorMessage: e.toString());
    }
  }

  // =========================================================================
  // App Data Restore
  // =========================================================================

  Future<bool> restoreAppDataBackup(String jsonContent) async {
    try {
      final decoded = jsonDecode(jsonContent) as Map<String, dynamic>;
      final checksum = decoded['checksum'] as String?;
      final dataMap = decoded['data'] as Map<String, dynamic>?;

      if (checksum == null || dataMap == null) return false;

      // Verify SHA-256 integrity
      final computedChecksum = sha256.convert(utf8.encode(jsonEncode(dataMap))).toString();
      if (checksum != computedChecksum) {
        throw Exception('ملف النسخة الاحتياطية تالف أو تم التعديل عليه (Checksum Mismatch)');
      }

      final tables = dataMap['tables'] as Map<String, dynamic>;

      // Restore profile prices
      if (tables.containsKey('profile_prices')) {
        final list = tables['profile_prices'] as List;
        for (final item in list) {
          await _db.into(_db.profilePricesTable).insert(
                ProfilePricesTableCompanion.insert(
                  connectionId: item['connectionId'] as int,
                  profileName: item['profileName'] as String,
                  price: (item['price'] as num).toDouble(),
                  currency: Value(item['currency'] as String? ?? 'YER'),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
      }

      // Restore templates
      if (tables.containsKey('templates')) {
        final list = tables['templates'] as List;
        for (final item in list) {
          await _db.into(_db.voucherTemplatesTable).insert(
                VoucherTemplatesTableCompanion.insert(
                  name: item['name'] as String,
                  headerText: Value(item['headerText'] as String?),
                  footerText: Value(item['footerText'] as String?),
                  showQrCode: Value(item['showQrCode'] as bool? ?? true),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
      }

      // Restore payments
      if (tables.containsKey('payments')) {
        final list = tables['payments'] as List;
        for (final item in list) {
          await _db.into(_db.paymentsTable).insert(
                PaymentsTableCompanion.insert(
                  connectionId: item['connectionId'] as int,
                  amount: (item['amount'] as num).toDouble(),
                  note: Value(item['note'] as String?),
                  receivedAt: Value(DateTime.parse(item['receivedAt'] as String)),
                ),
              );
        }
      }

      // Restore APs
      if (tables.containsKey('ap_devices')) {
        final list = tables['ap_devices'] as List;
        for (final item in list) {
          await _db.into(_db.apDevicesTable).insert(
                ApDevicesTableCompanion.insert(
                  connectionId: item['connectionId'] as int,
                  name: item['name'] as String,
                  ip: item['ip'] as String,
                  vendor: Value(item['vendor'] as String? ?? 'MikroTik'),
                ),
              );
        }
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  // =========================================================================
  // RouterOS Backup (/system/backup/save & /export)
  // =========================================================================

  Future<BackupResult> createRouterBackup({
    required RouterOsAdapter adapter,
    required int connectionId,
    bool isScriptExport = false,
  }) async {
    try {
      final timestampStr = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final baseName = 'mmpro_${isScriptExport ? "export" : "backup"}_$timestampStr';

      if (isScriptExport) {
        // RouterOS /export file=name
        await adapter.executeSentence(['/export', '=file=$baseName']);
      } else {
        // RouterOS /system/backup/save name=name
        await adapter.executeSentence(['/system/backup/save', '=name=$baseName']);
      }

      final ext = isScriptExport ? '.rsc' : '.backup';
      final fileNameOnRouter = '$baseName$ext';

      // Record in backup_log
      await _logBackup(
        connectionId: connectionId,
        kind: isScriptExport ? 'router_rsc' : 'router_backup',
        path: fileNameOnRouter,
      );

      return BackupResult(
        isSuccess: true,
        path: fileNameOnRouter,
        kind: isScriptExport ? 'router_rsc' : 'router_backup',
      );
    } catch (e) {
      return BackupResult(
        isSuccess: false,
        path: '',
        kind: isScriptExport ? 'router_rsc' : 'router_backup',
        errorMessage: e.toString(),
      );
    }
  }

  // =========================================================================
  // Backup Log History
  // =========================================================================

  Future<int> _logBackup({
    required int connectionId,
    required String kind,
    required String path,
  }) async {
    return await _db.into(_db.backupLogTable).insert(
      BackupLogTableCompanion.insert(
        connectionId: connectionId,
        kind: kind,
        path: path,
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<BackupLogTableData>> getBackupHistory(int connectionId) async {
    return await (_db.select(_db.backupLogTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> deleteBackupLog(int id) async {
    return await (_db.delete(_db.backupLogTable)..where((t) => t.id.equals(id))).go();
  }
}
