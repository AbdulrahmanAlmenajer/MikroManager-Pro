import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mikro_manager_pro/core/network/routeros_adapter.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';
import 'package:mikro_manager_pro/core/utils/audit_logger.dart';
import 'package:mikro_manager_pro/features/subscribers/data/subscribers_repository.dart';

class MockRouterOsAdapter extends Mock implements RouterOsAdapter {}

class MockAuditLogger extends Mock implements AuditLogger {}

void main() {
  group('Subscribers & Card Diagnosis Tests (Phase U2)', () {
    late MockRouterOsAdapter mockAdapter;
    late MockAuditLogger mockAudit;
    late SubscribersRepository repo;

    setUp(() {
      mockAdapter = MockRouterOsAdapter();
      mockAudit = MockAuditLogger();
      repo = SubscribersRepository(mockAudit);
    });

    test(
        'getHotspotSubscribers correctly merges hotspot users and active sessions',
        () async {
      when(() => mockAdapter.getHotspotUsers()).thenAnswer(
        (_) async => [
          {
            '.id': '*1',
            'name': 'card_user_1',
            'profile': '1Hour-Daily',
            'disabled': 'false',
            'limit-bytes-total': '104857600',
            'bytes-in': '1000',
            'bytes-out': '2000',
          },
          {
            '.id': '*2',
            'name': 'card_user_2',
            'profile': 'VIP-Unlimited',
            'disabled': 'true',
            'limit-bytes-total': '0',
          },
        ],
      );

      when(() => mockAdapter.getHotspotActive()).thenAnswer(
        (_) async => [
          {
            '.id': '*A1',
            'user': 'card_user_1',
            'address': '192.168.88.25',
            'mac-address': 'AA:BB:CC:DD:EE:01',
            'uptime': '15m20s',
          },
        ],
      );

      final subs = await repo.getHotspotSubscribers(mockAdapter);
      expect(subs.length, equals(2));

      // User 1 is active
      expect(subs[0].username, equals('card_user_1'));
      expect(subs[0].isActive, isTrue);
      expect(subs[0].ipAddress, equals('192.168.88.25'));
      expect(subs[0].macAddress, equals('AA:BB:CC:DD:EE:01'));
      expect(subs[0].isDisabled, isFalse);

      // User 2 is disabled
      expect(subs[1].username, equals('card_user_2'));
      expect(subs[1].isActive, isFalse);
      expect(subs[1].isDisabled, isTrue);
    });

    test('getPppoeSubscribers merges ppp secret and active sessions', () async {
      when(() => mockAdapter.executeSentence(['/ppp/secret/print'])).thenAnswer(
        (_) async => RouterOsResponse(
          isSuccess: true,
          data: [
            {
              '.id': '*P1',
              'name': 'home_fiber_10',
              'profile': 'Fiber-20M',
              'disabled': 'false',
              'remote-address': '10.10.10.2',
            },
          ],
        ),
      );

      when(() => mockAdapter.executeSentence(['/ppp/active/print'])).thenAnswer(
        (_) async => RouterOsResponse(
          isSuccess: true,
          data: [
            {
              '.id': '*PA1',
              'name': 'home_fiber_10',
              'service': 'pppoe',
              'caller-id': '00:11:22:33:44:55',
              'address': '10.10.10.2',
              'uptime': '2d4h',
            },
          ],
        ),
      );

      final subs = await repo.getPppoeSubscribers(mockAdapter);
      expect(subs.length, equals(1));
      expect(subs.first.username, equals('home_fiber_10'));
      expect(subs.first.isActive, isTrue);
      expect(subs.first.macAddress, equals('00:11:22:33:44:55'));
    });

    test('diagnoseCard reports not found when card does not exist', () async {
      when(() => mockAdapter.executeSentence(
          ['/ip/hotspot/user/print', '?name=non_existing_999'])).thenAnswer(
        (_) async => RouterOsResponse(isSuccess: true, data: []),
      );
      when(() => mockAdapter.isV7).thenReturn(true);
      when(() => mockAdapter.executeSentence(
          ['/user-manager/user/print', '?name=non_existing_999'])).thenAnswer(
        (_) async => RouterOsResponse(isSuccess: true, data: []),
      );

      final diag = await repo.diagnoseCard(mockAdapter, 'non_existing_999');
      expect(diag.exists, isFalse);
      expect(diag.rankedFailureReasons.first, contains('الكرت غير موجود'));
    });

    test('diagnoseCard detects disabled status and MAC binding', () async {
      when(() => mockAdapter
              .executeSentence(['/ip/hotspot/user/print', '?name=locked_card']))
          .thenAnswer(
        (_) async => RouterOsResponse(
          isSuccess: true,
          data: [
            {
              '.id': '*10',
              'name': 'locked_card',
              'profile': 'Standard',
              'disabled': 'true',
              'mac-address': '11:22:33:44:55:66',
            },
          ],
        ),
      );

      when(() => mockAdapter.executeSentence(
          ['/ip/hotspot/active/print', '?user=locked_card'])).thenAnswer(
        (_) async => RouterOsResponse(isSuccess: true, data: []),
      );

      final diag = await repo.diagnoseCard(mockAdapter, 'locked_card');
      expect(diag.exists, isTrue);
      expect(diag.rankedFailureReasons.any((r) => r.contains('معطل')), isTrue);
      expect(
          diag.rankedFailureReasons.any((r) => r.contains('مقيّد بعنوان MAC')),
          isTrue);
    });
  });
}
