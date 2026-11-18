import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/network/routeros_adapter.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';
import 'package:mikro_manager_pro/features/dashboard/data/dashboard_repository.dart';

class MockRouterOsAdapter extends Mock implements RouterOsAdapter {}

void main() {
  group('Interfaces & Traffic Tests (Phase U1)', () {
    late MockRouterOsAdapter mockAdapter;
    late DashboardRepository repo;
    late AppDatabase db;

    setUp(() {
      mockAdapter = MockRouterOsAdapter();
      repo = DashboardRepository();
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    });

    tearDown(() async {
      await db.close();
    });

    test('getDetailedInterfaces parses routeros response properly', () async {
      when(() => mockAdapter.executeSentence(['/interface/print'])).thenAnswer(
        (_) async => RouterOsResponse(
          isSuccess: true,
          data: [
            {
              '.id': '*1',
              'name': 'ether1-wan',
              'type': 'ether',
              'running': 'true',
              'disabled': 'false',
              'mac-address': '64:D1:54:12:34:56',
              'mtu': '1500',
              'rx-byte': '10485760',
              'tx-byte': '5242880',
            },
            {
              '.id': '*2',
              'name': 'bridge-lan',
              'type': 'bridge',
              'running': 'false',
              'disabled': 'true',
              'mac-address': '64:D1:54:12:34:57',
              'mtu': '1500',
              'rx-byte': '0',
              'tx-byte': '0',
            },
          ],
        ),
      );

      final interfaces = await repo.getDetailedInterfaces(mockAdapter);
      expect(interfaces.length, equals(2));
      expect(interfaces[0].name, equals('ether1-wan'));
      expect(interfaces[0].running, isTrue);
      expect(interfaces[0].disabled, isFalse);
      expect(interfaces[0].rxBytes, equals(10485760));

      expect(interfaces[1].name, equals('bridge-lan'));
      expect(interfaces[1].running, isFalse);
      expect(interfaces[1].disabled, isTrue);
    });

    test('recordDailySnapshot stores record in Drift interface_daily table',
        () async {
      await repo.recordDailySnapshot(
        db,
        connectionId: 1,
        interfaceName: 'ether1-wan',
        rxBytes: 50000000,
        txBytes: 25000000,
      );

      final snapshots = await repo.getDailySnapshots(db,
          connectionId: 1, interfaceName: 'ether1-wan');
      expect(snapshots.length, equals(1));
      expect(snapshots.first.interface, equals('ether1-wan'));
      expect(snapshots.first.rxBytes, equals(50000000));
      expect(snapshots.first.txBytes, equals(25000000));
    });
  });
}
