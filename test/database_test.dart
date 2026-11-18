import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database =
        AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
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

      final router = await (database.select(database.routersTable)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingle();
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

      final batch = await (database.select(database.voucherBatchesTable)
            ..where((tbl) => tbl.id.equals(batchId)))
          .getSingle();
      expect(batch.profileName, equals('VIP-Gold'));
      expect(batch.quantity, equals(25));
      expect(batch.totalAmount, equals(2500.0));
    });

    test('Can insert and query v3 profile_prices and usage_observations',
        () async {
      // 1. Insert profile price
      final priceId = await database.into(database.profilePricesTable).insert(
            ProfilePricesTableCompanion.insert(
              connectionId: 1,
              profileName: '1Hour-Daily',
              price: 200.0,
              currency: const Value('YER'),
            ),
          );
      expect(priceId, isPositive);

      final priceItem = await (database.select(database.profilePricesTable)
            ..where((tbl) => tbl.id.equals(priceId)))
          .getSingle();
      expect(priceItem.profileName, equals('1Hour-Daily'));
      expect(priceItem.price, equals(200.0));

      // 2. Insert usage observation
      final obsId = await database.into(database.usageObservationsTable).insert(
            UsageObservationsTableCompanion.insert(
              connectionId: 1,
              cardName: 'card_user_101',
              profile: '1Hour-Daily',
              dateIsApproximate: const Value(false),
            ),
          );
      expect(obsId, isPositive);

      final obs = await (database.select(database.usageObservationsTable)
            ..where((tbl) => tbl.id.equals(obsId)))
          .getSingle();
      expect(obs.cardName, equals('card_user_101'));
      expect(obs.dateIsApproximate, isFalse);
    });

    test('Can insert and query v3 AP devices and alert rules', () async {
      final apId = await database.into(database.apDevicesTable).insert(
            ApDevicesTableCompanion.insert(
              connectionId: 1,
              name: 'Sector West AP',
              ip: '192.168.88.50',
              vendor: const Value('MikroTik cAP ac'),
              accessState: const Value('ok'),
            ),
          );
      expect(apId, isPositive);

      final ap = await (database.select(database.apDevicesTable)
            ..where((tbl) => tbl.id.equals(apId)))
          .getSingle();
      expect(ap.name, equals('Sector West AP'));
      expect(ap.accessState, equals('ok'));

      final ruleId = await database.into(database.alertRulesTable).insert(
            AlertRulesTableCompanion.insert(
              connectionId: 1,
              type: 'cpu',
              target: 'CPU Load',
              threshold: 85.0,
              destination: const Value('telegram'),
            ),
          );
      expect(ruleId, isPositive);

      final rule = await (database.select(database.alertRulesTable)
            ..where((tbl) => tbl.id.equals(ruleId)))
          .getSingle();
      expect(rule.type, equals('cpu'));
      expect(rule.threshold, equals(85.0));
      expect(rule.enabled, isTrue);
    });
  });
}
