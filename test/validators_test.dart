import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/utils/validators.dart';

void main() {
  group('AppValidators Tests', () {
    test('Correctly identifies RFC 1918 private IPv4 addresses', () {
      expect(AppValidators.isPrivateOrLoopbackHost('192.168.88.1'), isTrue);
      expect(AppValidators.isPrivateOrLoopbackHost('10.0.0.1'), isTrue);
      expect(AppValidators.isPrivateOrLoopbackHost('172.16.0.5'), isTrue);
      expect(AppValidators.isPrivateOrLoopbackHost('172.31.255.254'), isTrue);
      expect(AppValidators.isPrivateOrLoopbackHost('127.0.0.1'), isTrue);
      expect(AppValidators.isPrivateOrLoopbackHost('localhost'), isTrue);
      expect(AppValidators.isPrivateOrLoopbackHost('169.254.1.1'), isTrue);
      expect(AppValidators.isPrivateOrLoopbackHost('router.local'), isTrue);
    });

    test('Correctly identifies public IP addresses as non-private', () {
      expect(AppValidators.isPrivateOrLoopbackHost('8.8.8.8'), isFalse);
      expect(AppValidators.isPrivateOrLoopbackHost('1.1.1.1'), isFalse);
      expect(AppValidators.isPrivateOrLoopbackHost('197.245.10.2'), isFalse);
      expect(AppValidators.isPrivateOrLoopbackHost('mikrotik.myddns.com'),
          isFalse);
    });

    test('Validates host format', () {
      expect(AppValidators.isValidHost('192.168.88.1'), isTrue);
      expect(AppValidators.isValidHost('router.lan'), isTrue);
      expect(AppValidators.isValidHost('my-router'), isTrue);
      expect(AppValidators.isValidHost(''), isFalse);
      expect(AppValidators.isValidHost('999.999.999.999'), isFalse);
    });
  });
}
