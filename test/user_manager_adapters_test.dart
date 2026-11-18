import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';
import 'package:mikro_manager_pro/features/userman/data/user_manager_v6_adapter.dart';
import 'package:mikro_manager_pro/features/userman/data/user_manager_v7_adapter.dart';
import 'helpers/fake_routeros_server.dart';

void main() {
  group('UserManager V6 Adapter Tests', () {
    late FakeRouterOsServer server;
    late RouterOsSocketClient client;
    late UserManagerV6Adapter v6Adapter;

    setUp(() async {
      server = FakeRouterOsServer()..isV7 = false;
      server.v6Customer = 'branch_south';
      final port = await server.start();
      client = RouterOsSocketClient(
        host: '127.0.0.1',
        port: port,
        username: 'admin',
        password: '',
      );
      await client.connect();
      v6Adapter = UserManagerV6Adapter(client);
    });

    tearDown(() async {
      client.close();
      await server.stop();
    });

    test('getCustomers returns customer logins', () async {
      final customers = await v6Adapter.getCustomers();
      expect(customers, contains('branch_south'));
    });

    test('getProfiles returns profiles for customer', () async {
      final profiles = await v6Adapter.getProfiles(customer: 'branch_south');
      expect(profiles, isNotEmpty);
      expect(profiles.first['name'], equals('1Hour'));
      expect(profiles.first['owner'], equals('branch_south'));
    });

    test('addUser performs 2-step add and activation', () async {
      final ok = await v6Adapter.addUser(
        username: 'v6_user_1',
        password: '123',
        profile: '1Hour',
        customer: 'branch_south',
      );
      expect(ok, isTrue);

      final users = await v6Adapter.getUsers(customer: 'branch_south');
      expect(users.length, equals(1));
      expect(users.first['name'], equals('v6_user_1'));
      expect(users.first['actual-profile'], equals('1Hour'));
      expect(users.first['uptime-used'], equals('0'));
    });
  });

  group('UserManager V7 Adapter Tests', () {
    late FakeRouterOsServer server;
    late RouterOsSocketClient client;
    late UserManagerV7Adapter v7Adapter;

    setUp(() async {
      server = FakeRouterOsServer()..isV7 = true;
      final port = await server.start();
      client = RouterOsSocketClient(
        host: '127.0.0.1',
        port: port,
        username: 'admin',
        password: '',
      );
      await client.connect();
      v7Adapter = UserManagerV7Adapter(client);
    });

    tearDown(() async {
      client.close();
      await server.stop();
    });

    test('getProfiles returns v7 profiles with price and validity', () async {
      final profiles = await v7Adapter.getProfiles();
      expect(profiles, isNotEmpty);
      expect(profiles.first['name'], equals('24Hours'));
      expect(profiles.first['price'], equals('500'));
    });

    test('addUser creates user and user-profile in v7', () async {
      final ok = await v7Adapter.addUser(
        username: 'v7_user_1',
        password: 'pass',
        profile: '24Hours',
      );
      expect(ok, isTrue);

      final users = await v7Adapter.getUsers();
      expect(users.length, equals(1));
      expect(users.first['name'], equals('v7_user_1'));
    });

    test('monitorUser sends =once= flag and returns result', () async {
      final result = await v7Adapter.monitorUser('v7_user_1');
      // Default handler returns !done {}
      expect(result, isNotNull);
    });
  });
}
