import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/features/vouchers/domain/voucher_generator_engine.dart';

void main() {
  group('VoucherGeneratorEngine Tests', () {
    test('Generates requested quantity of unique vouchers', () {
      const quantity = 50;
      final vouchers = VoucherGeneratorEngine.generateBatch(
        quantity: quantity,
        profile: '1Hour',
        price: 200,
        prefix: 'VIP-',
        codeLength: 8,
        codeType: VoucherCodeType.numeric,
      );

      expect(vouchers.length, equals(quantity));

      // Verify all unique
      final set = vouchers.map((v) => v.username).toSet();
      expect(set.length, equals(quantity));

      // Verify prefix & length
      for (final v in vouchers) {
        expect(v.username.startsWith('VIP-'), isTrue);
        expect(v.username.length, equals(8));
        expect(v.profile, equals('1Hour'));
        expect(v.price, equals(200));
      }
    });

    test('Generates 500 unique vouchers batch', () {
      final vouchers = VoucherGeneratorEngine.generateBatch(
        quantity: 500,
        profile: '500-Cards',
        price: 100,
        codeLength: 8,
        codeType: VoucherCodeType.numeric,
      );

      expect(vouchers.length, equals(500));
      final uniqueSet = vouchers.map((v) => v.username).toSet();
      expect(uniqueSet.length, equals(500));
    });

    test('Supports 3 Credential Modes correctly', () {
      // 1. Identical mode
      final identicalList = VoucherGeneratorEngine.generateBatch(
        quantity: 5,
        profile: 'P1',
        price: 100,
        credentialMode: CredentialMode.identical,
      );
      for (final v in identicalList) {
        expect(v.username, equals(v.password));
      }

      // 2. Username Only mode
      final userOnlyList = VoucherGeneratorEngine.generateBatch(
        quantity: 5,
        profile: 'P2',
        price: 100,
        credentialMode: CredentialMode.usernameOnly,
      );
      for (final v in userOnlyList) {
        expect(v.username.isNotEmpty, isTrue);
        expect(v.password, isEmpty);
      }

      // 3. Username + Separate Password mode
      final separateList = VoucherGeneratorEngine.generateBatch(
        quantity: 5,
        profile: 'P3',
        price: 100,
        credentialMode: CredentialMode.usernameAndPassword,
        passwordLength: 6,
      );
      for (final v in separateList) {
        expect(v.username.isNotEmpty, isTrue);
        expect(v.password.length, equals(6));
        expect(v.username != v.password, isTrue);
      }
    });
  });
}
