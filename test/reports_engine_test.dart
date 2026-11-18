import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/features/reports/data/reports_repository.dart';
import 'package:mikro_manager_pro/features/subscribers/data/subscribers_repository.dart';

void main() {
  group('Honest Reports Engine Tests (Phase U5)', () {
    late AppDatabase db;
    late ReportsRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      repo = ReportsRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Profile prices can be set, retrieved, and updated', () async {
      await repo.setProfilePrice(
        connectionId: 1,
        profileName: '1Hour',
        price: 100.0,
      );
      await repo.setProfilePrice(
        connectionId: 1,
        profileName: '1Day',
        price: 500.0,
      );

      var prices = await repo.getProfilePrices(1);
      expect(prices['1Hour'], 100.0);
      expect(prices['1Day'], 500.0);

      // Update existing
      await repo.setProfilePrice(
        connectionId: 1,
        profileName: '1Hour',
        price: 120.0,
      );
      prices = await repo.getProfilePrices(1);
      expect(prices['1Hour'], 120.0);
    });

    test('recordUsageObservations detects first usage and prevents duplicates',
        () async {
      final subscribers = [
        const SubscriberModel(
          id: '*1',
          username: 'user_unused',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          uptime: '0s',
          bytesIn: 0,
          bytesOut: 0,
        ),
        const SubscriberModel(
          id: '*2',
          username: 'user_active',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          uptime: '15m20s',
          bytesIn: 1048576,
          bytesOut: 524288,
        ),
        const SubscriberModel(
          id: '*3',
          username: 'user_traffic_only',
          profile: '1Day',
          type: SubscriberType.hotspot,
          bytesIn: 2048,
          bytesOut: 1024,
        ),
      ];

      // First run: should observe 2 used cards
      final count1 = await repo.recordUsageObservations(
        connectionId: 1,
        subscribers: subscribers,
      );
      expect(count1, 2);

      final obs = await repo.getUsageObservations(1);
      expect(obs.length, 2);
      expect(obs.map((o) => o.cardName).toSet(),
          containsAll(['user_active', 'user_traffic_only']));

      // Second run: no new usage, should insert 0 duplicates
      final count2 = await repo.recordUsageObservations(
        connectionId: 1,
        subscribers: subscribers,
      );
      expect(count2, 0);
    });

    test(
        'getHonestReportData accurately aggregates stock, unpriced profiles and estimated sales',
        () async {
      await repo.setProfilePrice(
        connectionId: 1,
        profileName: '1Hour',
        price: 100.0,
      );
      // 'UnpricedPlan' has no price set

      final subscribers = [
        // Unused
        const SubscriberModel(
          id: '*1',
          username: 'card_fresh',
          profile: '1Hour',
          type: SubscriberType.hotspot,
        ),
        // Active
        const SubscriberModel(
          id: '*2',
          username: 'card_online',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          uptime: '5m',
        ),
        // Expired
        const SubscriberModel(
          id: '*3',
          username: 'card_done',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          limitBytesTotal: 1000,
          bytesIn: 600,
          bytesOut: 500,
        ),
        // Unpriced
        const SubscriberModel(
          id: '*4',
          username: 'card_special',
          profile: 'UnpricedPlan',
          type: SubscriberType.hotspot,
        ),
      ];

      await repo.recordUsageObservations(
        connectionId: 1,
        subscribers: subscribers,
      );

      // Add a manual payment
      await repo.addPayment(
        connectionId: 1,
        amount: 300.0,
        note: 'دفعة من نقطة بيع المحطة',
      );

      final report = await repo.getHonestReportData(
        connectionId: 1,
        subscribers: subscribers,
      );

      // Stock checks
      expect(report.stock.totalCards, 4);
      expect(report.stock.unusedCards,
          2); // card_fresh (1Hour) and card_special (UnpricedPlan)
      expect(report.stock.unusedValue,
          100.0); // 100 from 1Hour + 0 from UnpricedPlan
      expect(report.stock.activeCards, 1); // card_online
      expect(report.stock.activeValue, 100.0);
      expect(report.stock.expiredCards, 1); // card_done
      expect(report.stock.unpricedProfiles, contains('UnpricedPlan'));

      // Payments checks
      expect(report.payments.totalPayments, 300.0);
      expect(report.payments.payments.length, 1);
    });

    test(
        'cleanOldObservations removes observations older than retention period',
        () async {
      // Insert old observation manually
      await db.into(db.usageObservationsTable).insert(
            UsageObservationsTableCompanion.insert(
              connectionId: 1,
              cardName: 'old_card_1',
              profile: '1Hour',
              firstSeenAt:
                  Value(DateTime.now().subtract(const Duration(days: 45))),
            ),
          );

      // Insert recent observation
      await db.into(db.usageObservationsTable).insert(
            UsageObservationsTableCompanion.insert(
              connectionId: 1,
              cardName: 'recent_card_2',
              profile: '1Hour',
              firstSeenAt:
                  Value(DateTime.now().subtract(const Duration(days: 5))),
            ),
          );

      final deletedCount = await repo.cleanOldObservations(1, keepDays: 30);
      expect(deletedCount, 1);

      final remaining = await repo.getUsageObservations(1);
      expect(remaining.length, 1);
      expect(remaining.first.cardName, 'recent_card_2');
    });
  });
}
