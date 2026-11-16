import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
  });

  tearDown(() async {
    await database.close();
  });

  group('Drift Database Unit Tests', () {
    test('Can insert and retrieve router in local database', () async {
      final id = await database.into(database.routersTable).insert(
        RoutersTableCompanion.insert(
          name: 'Main MikroTik Core',
          ipAddress: '192.168.88.1',
          apiPort: const Value(8728),
          username: const Value('admin'),
          useSsl: const Value(false),
          useRestApi: const Value(false),
        ),
      );

      final router = await (database.select(database.routersTable)..where((tbl) => tbl.id.equals(id))).getSingle();
      expect(router.name, equals('Main MikroTik Core'));
      expect(router.ipAddress, equals('192.168.88.1'));
      expect(router.apiPort, equals(8728));
    });

    test('Can insert and retrieve voucher batch', () async {
      final batchId = await database.into(database.voucherBatchesTable).insert(
        VoucherBatchesTableCompanion.insert(
          routerId: 1,
          profileName: 'VIP-Gold',
          quantity: 25,
          prefix: const Value('VIP-'),
          codeLength: const Value(8),
          vouchersJson: '[]',
          unitPrice: const Value(100.0),
          totalAmount: const Value(2500.0),
        ),
      );

      final batch = await (database.select(database.voucherBatchesTable)..where((tbl) => tbl.id.equals(batchId))).getSingle();
      expect(batch.profileName, equals('VIP-Gold'));
      expect(batch.quantity, equals(25));
      expect(batch.totalAmount, equals(2500.0));
    });
  });
}
