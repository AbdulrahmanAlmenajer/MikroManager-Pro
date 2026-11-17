import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/network/routeros_adapter.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';
import 'package:mikro_manager_pro/features/access_points/data/ap_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRouterOsAdapter extends Mock implements RouterOsAdapter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Access Points Tests (Phase U6)', () {
    late AppDatabase db;
    late ApRepository repo;
    late MockRouterOsAdapter mockAdapter;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      repo = ApRepository(db);
      mockAdapter = MockRouterOsAdapter();
    });

    tearDown(() async {
      await db.close();
    });

    test('addAp inserts device in Drift and getAllAps retrieves it', () async {
      final id = await repo.addAp(
        connectionId: 1,
        name: 'AP-Sector-North',
        ip: '192.168.88.20',
        vendor: 'Ubiquiti',
      );

      expect(id, isPositive);

      final list = await repo.getAllAps(1);
      expect(list.length, 1);
      expect(list.first.name, 'AP-Sector-North');
      expect(list.first.ip, '192.168.88.20');
      expect(list.first.vendor, 'Ubiquiti');
      expect(list.first.accessState, 'unknown');
    });

    test('updateAp modifies device properties in database', () async {
      final id = await repo.addAp(
        connectionId: 1,
        name: 'AP-Old-Name',
        ip: '192.168.88.21',
      );

      final updated = await repo.updateAp(
        id: id,
        name: 'AP-New-Name',
        ip: '192.168.88.22',
        vendor: 'TP-Link',
      );
      expect(updated, isTrue);

      final list = await repo.getAllAps(1);
      expect(list.first.name, 'AP-New-Name');
      expect(list.first.ip, '192.168.88.22');
      expect(list.first.vendor, 'TP-Link');
    });

    test('deleteAp removes device from database', () async {
      final id = await repo.addAp(
        connectionId: 1,
        name: 'AP-To-Delete',
        ip: '192.168.88.99',
      );

      final deletedCount = await repo.deleteAp(id);
      expect(deletedCount, 1);

      final list = await repo.getAllAps(1);
      expect(list.isEmpty, isTrue);
    });

    test('discoverNeighbors queries /ip/neighbor/print and infers vendors', () async {
      when(() => mockAdapter.executeSentence(['/ip/neighbor/print'])).thenAnswer(
        (_) async => RouterOsResponse(
          isSuccess: true,
          data: [
            {
              'identity': 'NanoStation Loco M5',
              'address': '192.168.88.25',
              'mac-address': '00:27:22:11:22:33',
              'platform': 'Ubiquiti AirMax',
              'interface': 'ether2',
            },
            {
              'identity': 'RB951G-2HnD',
              'address': '192.168.88.30',
              'mac-address': 'D4:CA:6D:44:55:66',
              'platform': 'MikroTik',
              'interface': 'ether3',
            },
            {
              'identity': 'CPE510 Pharos',
              'address': '192.168.88.35',
              'mac-address': 'E8:DE:27:77:88:99',
              'platform': '',
              'interface': 'ether4',
            },
          ],
        ),
      );

      final discovered = await repo.discoverNeighbors(mockAdapter);
      expect(discovered.length, 3);

      expect(discovered[0].vendor, 'Ubiquiti');
      expect(discovered[0].ip, '192.168.88.25');

      expect(discovered[1].vendor, 'MikroTik');
      expect(discovered[1].ip, '192.168.88.30');

      expect(discovered[2].vendor, 'TP-Link');
      expect(discovered[2].ip, '192.168.88.35');
    });
  });
}
