import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/network/routeros_adapter.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';
import 'package:mikro_manager_pro/features/backup/data/backup_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRouterOsAdapter extends Mock implements RouterOsAdapter {}

void main() {
  group('Backup System Tests (Phase U9)', () {
    late AppDatabase db;
    late BackupRepository repo;
    late MockRouterOsAdapter mockAdapter;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      repo = BackupRepository(db);
      mockAdapter = MockRouterOsAdapter();
    });

    tearDown(() async {
      await db.close();
    });

    test('restoreAppDataBackup succeeds with valid checksum and restores data', () async {
      final sampleData = {
        'version': 3.1,
        'connectionId': 1,
        'tables': {
          'profile_prices': [
            {
              'connectionId': 1,
              'profileName': 'Speed_10M',
              'price': 750.0,
              'currency': 'YER',
            }
          ],
          'templates': [
            {
              'name': 'Modern Blue',
              'headerText': 'شبكة المستقبل',
              'footerText': 'أهلاً بكم',
              'showQrCode': true,
            }
          ],
          'payments': [],
          'ap_devices': [],
        },
      };

      final jsonStr = jsonEncode(sampleData);
      final validChecksum = sha256.convert(utf8.encode(jsonStr)).toString();

      final payload = {
        'checksum': validChecksum,
        'data': sampleData,
      };

      final restored = await repo.restoreAppDataBackup(jsonEncode(payload));
      expect(restored, isTrue);

      // Verify restored tables
      final prices = await db.select(db.profilePricesTable).get();
      expect(prices.length, 1);
      expect(prices.first.profileName, 'Speed_10M');
      expect(prices.first.price, 750.0);

      final templates = await db.select(db.voucherTemplatesTable).get();
      expect(templates.any((t) => t.name == 'Modern Blue'), isTrue);
    });

    test('restoreAppDataBackup rejects tampered backup with mismatched checksum', () async {
      final sampleData = {
        'version': 3.1,
        'tables': {'profile_prices': []},
      };

      final payload = {
        'checksum': 'INVALID_TAMPERED_CHECKSUM_HASH',
        'data': sampleData,
      };

      final restored = await repo.restoreAppDataBackup(jsonEncode(payload));
      expect(restored, isFalse);
    });

    test('createRouterBackup executes /system/backup/save and logs to backup_log', () async {
      when(() => mockAdapter.executeSentence(any())).thenAnswer(
        (_) async => RouterOsResponse(
          isSuccess: true,
          data: [],
        ),
      );

      final result = await repo.createRouterBackup(
        adapter: mockAdapter,
        connectionId: 1,
        isScriptExport: false,
      );

      expect(result.isSuccess, isTrue);
      expect(result.kind, 'router_backup');
      expect(result.path, endsWith('.backup'));

      final logs = await repo.getBackupHistory(1);
      expect(logs.length, 1);
      expect(logs.first.kind, 'router_backup');
      expect(logs.first.path, endsWith('.backup'));
    });

    test('createRouterBackup with script export executes /export and logs router_rsc', () async {
      when(() => mockAdapter.executeSentence(any())).thenAnswer(
        (_) async => RouterOsResponse(
          isSuccess: true,
          data: [],
        ),
      );

      final result = await repo.createRouterBackup(
        adapter: mockAdapter,
        connectionId: 1,
        isScriptExport: true,
      );

      expect(result.isSuccess, isTrue);
      expect(result.kind, 'router_rsc');
      expect(result.path, endsWith('.rsc'));

      final logs = await repo.getBackupHistory(1);
      expect(logs.first.kind, 'router_rsc');
    });
  });
}
