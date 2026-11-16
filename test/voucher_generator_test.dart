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

    test('Generates alphanumeric vouchers correctly', () {
      final vouchers = VoucherGeneratorEngine.generateBatch(
        quantity: 20,
        profile: 'DayPass',
        price: 500,
        prefix: '',
        codeLength: 6,
        codeType: VoucherCodeType.alphanumeric,
        sameUserAndPass: false,
      );

      expect(vouchers.length, equals(20));
      for (final v in vouchers) {
        expect(v.username.length, equals(6));
        expect(v.password.isNotEmpty, isTrue);
      }
    });
  });
}
