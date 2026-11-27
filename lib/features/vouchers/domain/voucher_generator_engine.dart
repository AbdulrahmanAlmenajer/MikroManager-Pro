import 'dart:math';
import '../../../core/utils/pdf_generator_helper.dart';

enum VoucherCodeType {
  numeric, // 0-9
  alphanumeric, // 2-9, A-Z (excluding confusing 0/O, 1/I)
  alphaUpper, // A-Z
}

enum CredentialMode {
  identical, // اسم مستخدم وكلمة مرور متطابقان
  usernameOnly, // اسم مستخدم فقط (بدون كلمة مرور)
  usernameAndPassword, // اسم مستخدم + كلمة مرور منفصلة
}

class VoucherGeneratorEngine {
  static const String _digits = '0123456789';
  static const String _safeAlphanumeric = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  static const String _safeAlpha = 'ABCDEFGHJKLMNPQRSTUVWXYZ';

  /// Generate a batch of unique voucher cards with optional sequential serial numbers
  static List<VoucherCardData> generateBatch({
    required int quantity,
    required String profile,
    required double price,
    String prefix = '',
    int codeLength = 8,
    VoucherCodeType codeType = VoucherCodeType.numeric,
    CredentialMode credentialMode = CredentialMode.identical,
    bool? sameUserAndPass, // For backward compatibility
    int passwordLength = 4,
    VoucherCodeType passwordCodeType = VoucherCodeType.numeric,
    String? validity,
    String? networkName,
    bool enableSerial = false,
    String serialPrefix = 'SN-',
    int serialStart = 1,
    int serialPadding = 4,
  }) {
    final Random random = Random.secure();
    final Set<String> generatedCodes = {};
    final List<VoucherCardData> vouchers = [];

    // Map legacy parameter if provided
    CredentialMode effectiveMode = credentialMode;
    if (sameUserAndPass != null) {
      effectiveMode = sameUserAndPass
          ? CredentialMode.identical
          : CredentialMode.usernameAndPassword;
    }

    String getCharPool(VoucherCodeType type) {
      switch (type) {
        case VoucherCodeType.numeric:
          return _digits;
        case VoucherCodeType.alphanumeric:
          return _safeAlphanumeric;
        case VoucherCodeType.alphaUpper:
          return _safeAlpha;
      }
    }

    final charPool = getCharPool(codeType);
    final passCharPool = getCharPool(passwordCodeType);

    final targetLength = codeLength - prefix.length;
    final int safeTargetLength = targetLength > 0 ? targetLength : 4;

    int serialIndex = 0;
    while (vouchers.length < quantity) {
      final StringBuffer codeBuffer = StringBuffer(prefix);
      for (int i = 0; i < safeTargetLength; i++) {
        codeBuffer.write(charPool[random.nextInt(charPool.length)]);
      }
      final code = codeBuffer.toString();

      if (!generatedCodes.contains(code)) {
        generatedCodes.add(code);

        String password;
        switch (effectiveMode) {
          case CredentialMode.identical:
            password = code;
            break;
          case CredentialMode.usernameOnly:
            password = '';
            break;
          case CredentialMode.usernameAndPassword:
            final StringBuffer passBuffer = StringBuffer();
            for (int i = 0; i < passwordLength; i++) {
              passBuffer
                  .write(passCharPool[random.nextInt(passCharPool.length)]);
            }
            password = passBuffer.toString();
            break;
        }

        final serial = enableSerial
            ? '$serialPrefix${(serialStart + serialIndex).toString().padLeft(serialPadding, '0')}'
            : null;
        serialIndex++;

        vouchers.add(
          VoucherCardData(
            username: code,
            password: password,
            profile: profile,
            price: price,
            validity: validity,
            networkName: networkName,
            serialNumber: serial,
          ),
        );
      }
    }

    return vouchers;
  }
}
