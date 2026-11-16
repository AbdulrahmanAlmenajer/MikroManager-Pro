import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';

void main() {
  group('RouterOS Protocol & Model Tests', () {
    test('RouterOsSentence parses attributes correctly', () {
      final sentence = RouterOsSentence(
        command: '!re',
        attributes: {
          'name': 'test_user',
          'profile': 'default',
          'uptime': '1h20m',
        },
      );

      expect(sentence.command, equals('!re'));
      expect(sentence.attributes['name'], equals('test_user'));
      expect(sentence.attributes['profile'], equals('default'));
    });

    test('RouterOsResponse success flag and data list', () {
      final response = RouterOsResponse(
        isSuccess: true,
        data: [
          {'name': 'admin', 'group': 'full'},
          {'name': 'operator', 'group': 'read'},
        ],
      );

      expect(response.isSuccess, isTrue);
      expect(response.data.length, equals(2));
      expect(response.errorMessage, isNull);
    });
  });
}
