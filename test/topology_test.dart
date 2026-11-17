import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/features/subscribers/data/subscribers_repository.dart';
import 'package:mikro_manager_pro/features/topology/data/topology_repository.dart';

void main() {
  group('Users Map & Network Topology Tests (Phase U7)', () {
    late AppDatabase db;
    late TopologyRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      repo = TopologyRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('matchSubscribersToAps applies evidence ladder correctly', () async {
      final aps = [
        const ApDevicesTableData(
          id: 1,
          connectionId: 1,
          name: 'Sector-East',
          ip: '192.168.10.1',
          vendor: 'Ubiquiti',
          accessState: 'ok',
        ),
        const ApDevicesTableData(
          id: 2,
          connectionId: 1,
          name: 'Omni-Tower',
          ip: '192.168.20.1',
          vendor: 'MikroTik',
          accessState: 'ok',
        ),
      ];

      final subscribers = [
        // 1. Confirmed by comment
        const SubscriberModel(
          id: '*1',
          username: 'client_confirmed',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          isActive: true,
          ipAddress: '10.0.0.5',
          macAddress: 'AA:BB:CC:DD:EE:01',
          comment: 'Connected to Sector-East via station',
        ),
        // 2. Likely by subnet
        const SubscriberModel(
          id: '*2',
          username: 'client_likely',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          isActive: true,
          ipAddress: '192.168.20.55',
          macAddress: 'AA:BB:CC:DD:EE:02',
        ),
        // 3. Unmatched
        const SubscriberModel(
          id: '*3',
          username: 'client_unmatched',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          isActive: true,
          ipAddress: '172.16.5.10',
          macAddress: 'AA:BB:CC:DD:EE:03',
        ),
      ];

      final results = await repo.matchSubscribersToAps(
        connectionId: 1,
        subscribers: subscribers,
        aps: aps,
      );

      expect(results.length, 3);

      // Client 1: Confirmed
      expect(results[0].username, 'client_confirmed');
      expect(results[0].apId, 1);
      expect(results[0].confidence, 'confirmed');

      // Client 2: Likely
      expect(results[1].username, 'client_likely');
      expect(results[1].apId, 2);
      expect(results[1].confidence, 'likely');

      // Client 3: Unmatched
      expect(results[2].username, 'client_unmatched');
      expect(results[2].apId, isNull);
      expect(results[2].confidence, 'unmatched');

      // Verify Drift storage
      final storedMatches = await db.select(db.userApMatchesTable).get();
      expect(storedMatches.length, 3);
    });

    test('saveSnapshot and getLatestSnapshot persist graph JSON', () async {
      final sampleGraph = {
        'router': {'host': '192.168.88.1', 'model': 'RB4011'},
        'apsCount': 2,
        'clientsCount': 15,
      };

      final snapshotId = await repo.saveSnapshot(
        connectionId: 1,
        graphData: sampleGraph,
      );
      expect(snapshotId, isPositive);

      final loaded = await repo.getLatestSnapshot(1);
      expect(loaded, isNotNull);
      expect(loaded!['apsCount'], 2);
      expect(loaded['clientsCount'], 15);
      expect(loaded['router']['model'], 'RB4011');
    });
  });
}
