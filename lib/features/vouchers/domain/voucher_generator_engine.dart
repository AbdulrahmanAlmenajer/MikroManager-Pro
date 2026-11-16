import 'dart:math';
import '../../../core/utils/pdf_generator_helper.dart';

enum VoucherCodeType {
  numeric, // 0-9
  alphanumeric, // 2-9, A-Z (excluding confusing 0/O, 1/I)
  alphaUpper, // A-Z
}

class VoucherGeneratorEngine {
  static const String _digits = '0123456789';
  static const String _safeAlphanumeric = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  static const String _safeAlpha = 'ABCDEFGHJKLMNPQRSTUVWXYZ';

  /// Generate a batch of unique voucher cards
  static List<VoucherCardData> generateBatch({
    required int quantity,
    required String profile,
    required double price,
    String prefix = '',
    int codeLength = 8,
    VoucherCodeType codeType = VoucherCodeType.numeric,
    bool sameUserAndPass = true,
    String? validity,
    String? networkName,
  }) {
    final Random random = Random.secure();
    final Set<String> generatedCodes = {};
    final List<VoucherCardData> vouchers = [];

    String charPool;
    switch (codeType) {
      case VoucherCodeType.numeric:
        charPool = _digits;
        break;
      case VoucherCodeType.alphanumeric:
        charPool = _safeAlphanumeric;
        break;
      case VoucherCodeType.alphaUpper:
        charPool = _safeAlpha;
        break;
    }

    final targetLength = codeLength - prefix.length;
    final int safeTargetLength = targetLength > 0 ? targetLength : 4;

    while (vouchers.length < quantity) {
      final StringBuffer codeBuffer = StringBuffer(prefix);
      for (int i = 0; i < safeTargetLength; i++) {
        codeBuffer.write(charPool[random.nextInt(charPool.length)]);
      }
      final code = codeBuffer.toString();

      if (!generatedCodes.contains(code)) {
        generatedCodes.add(code);

        String password = code;
        if (!sameUserAndPass) {
          final StringBuffer passBuffer = StringBuffer();
          for (int i = 0; i < 4; i++) {
            passBuffer.write(_digits[random.nextInt(_digits.length)]);
          }
          password = passBuffer.toString();
        }

        vouchers.add(
          VoucherCardData(
            username: code,
            password: password,
            profile: profile,
            price: price,
            validity: validity,
            networkName: networkName,
          ),
        );
      }
    }

    return vouchers;
  }
}
