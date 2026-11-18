import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/network/routeros_adapter.dart';
import 'package:mikro_manager_pro/core/network/routeros_exceptions.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';
import 'helpers/fake_routeros_server.dart';

void main() {
  group('Fake RouterOS TCP Integration Tests (Phase U0)', () {
    late FakeRouterOsServer server;

    setUp(() async {
      server = FakeRouterOsServer();
    });

    tearDown(() async {
      await server.stop();
    });

    test('v6.49 connection: correctly detects major version 6 and customer',
        () async {
      server.isV7 = false;
      server.v6Customer = 'net_admin';
      final port = await server.start();

      final adapter = RouterOsBinaryAdapter(
        host: '127.0.0.1',
        port: port,
        username: 'admin',
        password: '',
      );

      final connected = await adapter.connect();
      expect(connected, isTrue);
      expect(adapter.isV7, isFalse);

      final customers = await adapter.getUserManagerCustomers();
      expect(customers, contains('net_admin'));

      adapter.disconnect();
    });

    test(
        'v6.49 UM: addUserManagerUser creates user and activates profile with custom owner',
        () async {
      server.isV7 = false;
      server.v6Customer = 'branch_owner';
      final port = await server.start();

      final adapter = RouterOsBinaryAdapter(
        host: '127.0.0.1',
        port: port,
        username: 'admin',
        password: '',
      );
      await adapter.connect();

      final added = await adapter.addUserManagerUser(
        username: 'voucher_001',
        password: 'pass',
        profile: '1Hour',
        customer: 'branch_owner',
      );
      expect(added, isTrue);

      final users = await adapter.getUserManagerUsers();
      expect(users.length, equals(1));
      // Verify username normalized to 'name'
      expect(users.first['name'], equals('voucher_001'));
      expect(users.first['customer'], equals('branch_owner'));
      expect(users.first['actual-profile'], equals('1Hour'));

      adapter.disconnect();
    });

    test('v7.18 connection: correctly detects v7 and supports empty sentence',
        () async {
      server.isV7 = true;
      server.sendEmptyOnEmptyTables = true;
      final port = await server.start();

      final adapter = RouterOsBinaryAdapter(
        host: '127.0.0.1',
        port: port,
        username: 'admin',
        password: '',
      );
      await adapter.connect();
      expect(adapter.isV7, isTrue);

      // RouterOS 7.18+ untagged !empty sentence: must return empty list without hang
      final users = await adapter.getUserManagerUsers();
      expect(users, isEmpty);

      adapter.disconnect();
    });

    test('Fault injection: timeout triggers RouterOsTimeoutException',
        () async {
      server.triggerTimeout = true;
      final port = await server.start();

      final client = RouterOsSocketClient(
        host: '127.0.0.1',
        port: port,
        username: 'admin',
        password: '',
        timeout: const Duration(milliseconds: 500),
      );

      expect(
        () async => await client.connect(),
        throwsA(isA<RouterOsTimeoutException>()),
      );
      client.close();
    });

    test('Fault injection: trap error reports proper message without crashing',
        () async {
      server.triggerTrapMessage = 'syntax error in command';
      final port = await server.start();

      final adapter = RouterOsBinaryAdapter(
        host: '127.0.0.1',
        port: port,
        username: 'admin',
        password: '',
      );
      // Login will receive trap
      final client = RouterOsSocketClient(
        host: '127.0.0.1',
        port: port,
        username: 'admin',
        password: '',
        timeout: const Duration(seconds: 2),
      );

      // Connect sends /login, server replies with !trap
      expect(
        () async => await client.connect(),
        throwsA(isA<RouterOsException>()),
      );
      client.close();
      adapter.disconnect();
    });
  });
}
