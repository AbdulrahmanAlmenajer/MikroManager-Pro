import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/network/routeros_adapter.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';
import 'package:mikro_manager_pro/features/telegram_bot/data/alerts_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRouterOsAdapter extends Mock implements RouterOsAdapter {}

void main() {
  group('Alerts & Rogue DHCP Tests (Phase U8)', () {
    late AppDatabase db;
    late AlertsRepository repo;
    late MockRouterOsAdapter mockAdapter;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      repo = AlertsRepository(db);
      mockAdapter = MockRouterOsAdapter();
    });

    tearDown(() async {
      await db.close();
    });

    test('addTrustedDhcpServer and getTrustedDhcpServers work correctly',
        () async {
      final id = await repo.addTrustedDhcpServer(
        connectionId: 1,
        serverIp: '192.168.88.1',
        interface: 'bridge1',
      );
      expect(id, isPositive);

      final list = await repo.getTrustedDhcpServers(1);
      expect(list.length, 1);
      expect(list.first.serverIp, '192.168.88.1');
      expect(list.first.interface, 'bridge1');
    });

    test(
        'scanForRogueDhcp classifies servers and logs alert events for rogue servers',
        () async {
      // 1. Setup trusted server
      await repo.addTrustedDhcpServer(
        connectionId: 1,
        serverIp: '192.168.88.1',
        interface: 'bridge1',
      );

      // 2. Mock router alert response containing one valid and one unknown rogue server
      when(() => mockAdapter.executeSentence(['/ip/dhcp-server/alert/print']))
          .thenAnswer(
        (_) async => RouterOsResponse(
          isSuccess: true,
          data: [
            {
              'server-address': '192.168.88.1',
              'interface': 'bridge1',
              'valid-server': '192.168.88.1',
            },
            {
              'unknown-server': '192.168.88.254',
              'interface': 'ether3',
              'valid-server': 'false',
            },
          ],
        ),
      );

      final alerts = await repo.scanForRogueDhcp(
        connectionId: 1,
        adapter: mockAdapter,
      );

      expect(alerts.length, 2);

      // Server 1: Trusted
      expect(alerts[0].serverIp, '192.168.88.1');
      expect(alerts[0].isTrusted, isTrue);
      expect(alerts[0].status, 'trusted');

      // Server 2: Rogue
      expect(alerts[1].serverIp, '192.168.88.254');
      expect(alerts[1].isTrusted, isFalse);
      expect(alerts[1].status, 'rogue');

      // Verify that an alert event was logged in Drift table
      final storedEvents = await repo.getAlertEvents(1);
      expect(storedEvents.length, 1);
      expect(storedEvents.first.details, contains('192.168.88.254'));
    });

    test('isQuietHoursActive calculates quiet time correctly', () {
      const quiet = QuietHoursTableData(
        id: 1,
        connectionId: 1,
        startMinute: 23 * 60, // 23:00 (1380)
        endMinute: 6 * 60, // 06:00 (360)
        days: '1,2,3,4,5,6,7',
        muteUntil: null,
      );

      // 1. Midnight: 02:00 -> should be quiet
      final nightTime = DateTime(2026, 11, 18, 2, 0);
      expect(repo.isQuietHoursActive(quiet, nightTime), isTrue);

      // 2. Noon: 12:00 -> should NOT be quiet
      final dayTime = DateTime(2026, 11, 18, 12, 0);
      expect(repo.isQuietHoursActive(quiet, dayTime), isFalse);

      // 3. MuteUntil override in the future
      final mutedQuiet = QuietHoursTableData(
        id: 1,
        connectionId: 1,
        startMinute: 0,
        endMinute: 0,
        days: '1,2,3,4,5,6,7',
        muteUntil: DateTime(2026, 11, 18, 15, 0),
      );
      expect(repo.isQuietHoursActive(mutedQuiet, dayTime), isTrue);
    });

    test('generateNetwatchScript produces valid RouterOS command with token',
        () {
      final script = repo.generateNetwatchScript(
        apName: 'East-Sector',
        apIp: '192.168.88.50',
        botToken: 'TEST_TOKEN_123',
        chatId: '987654321',
        intervalSeconds: 45,
      );

      expect(script, contains('/tool netwatch add host=192.168.88.50'));
      expect(script, contains('interval=45s'));
      expect(script, contains('TEST_TOKEN_123'));
      expect(script, contains('987654321'));
      expect(script, contains('AP East-Sector (192.168.88.50) is UP'));
    });
  });
}
