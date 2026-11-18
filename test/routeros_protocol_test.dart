import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/network/routeros_socket_client.dart';
import 'package:mikro_manager_pro/core/network/routeros_exceptions.dart';

void main() {
  group('RouterOS Protocol & Model Tests', () {
    test('RouterOsSentence parses attributes and tags correctly', () {
      final sentence = RouterOsSentence(
        command: '!re',
        tag: 'tag_1',
        attributes: {
          'name': 'test_user',
          'profile': 'default',
          'uptime': '1h20m',
        },
      );

      expect(sentence.command, equals('!re'));
      expect(sentence.tag, equals('tag_1'));
      expect(sentence.attributes['name'], equals('test_user'));
      expect(sentence.attributes['profile'], equals('default'));
    });

    test('RouterOsResponse success flag and data list', () {
      final response = RouterOsResponse(
        isSuccess: true,
        tag: 'tag_1',
        data: [
          {'name': 'admin', 'group': 'full'},
          {'name': 'operator', 'group': 'read'},
        ],
      );

      expect(response.isSuccess, isTrue);
      expect(response.data.length, equals(2));
      expect(response.errorMessage, isNull);
    });

    test('MikroTik 1 to 5 byte length encoding and decoding', () {
      // 1-byte length (< 0x80)
      final len1 = RouterOsSocketClient.encodeLength(45);
      expect(len1.length, equals(1));
      final dec1 = RouterOsSocketClient.decodeLength(len1)!;
      expect(dec1.length, equals(45));
      expect(dec1.headerSize, equals(1));

      // 2-byte length (< 0x4000)
      final len2 = RouterOsSocketClient.encodeLength(500);
      expect(len2.length, equals(2));
      final dec2 = RouterOsSocketClient.decodeLength(len2)!;
      expect(dec2.length, equals(500));
      expect(dec2.headerSize, equals(2));

      // 3-byte length (< 0x200000)
      final len3 = RouterOsSocketClient.encodeLength(70000);
      expect(len3.length, equals(3));
      final dec3 = RouterOsSocketClient.decodeLength(len3)!;
      expect(dec3.length, equals(70000));
      expect(dec3.headerSize, equals(3));

      // 4-byte length (< 0x10000000)
      final len4 = RouterOsSocketClient.encodeLength(3000000);
      expect(len4.length, equals(4));
      final dec4 = RouterOsSocketClient.decodeLength(len4)!;
      expect(dec4.length, equals(3000000));
      expect(dec4.headerSize, equals(4));

      // 5-byte length (>= 0x10000000)
      final len5 = RouterOsSocketClient.encodeLength(300000000);
      expect(len5.length, equals(5));
      expect(len5.first, equals(0xF0));
      final dec5 = RouterOsSocketClient.decodeLength(len5)!;
      expect(dec5.length, equals(300000000));
      expect(dec5.headerSize, equals(5));
    });

    test(
        'Legacy MD5 challenge response generation matches RouterOS specification',
        () {
      const password = 'test_password';
      const challenge = '1234567890abcdef1234567890abcdef';

      final hash = RouterOsSocketClient.computeLegacyMd5(password, challenge);
      expect(hash.startsWith('00'), isTrue);
      expect(hash.length, equals(34)); // '00' + 32-character hex MD5
    });

    test('Typed exceptions provide expected Arabic messages', () {
      const exTimeout = RouterOsTimeoutException();
      expect(exTimeout.message, contains('انتهت مهلة الاتصال'));

      const exPortClosed = RouterOsPortClosedException();
      expect(exPortClosed.message, contains('/ip service enable api'));

      const exAuth = RouterOsAuthException();
      expect(exAuth.message, contains('اسم المستخدم أو كلمة المرور غير صحيحة'));

      const exTls = RouterOsTlsException();
      expect(exTls.message, contains('شهادة TLS/SSL'));

      const exPolicy = RouterOsMissingPolicyException();
      expect(exPolicy.message, contains('صلاحية API'));
    });
  });
}
