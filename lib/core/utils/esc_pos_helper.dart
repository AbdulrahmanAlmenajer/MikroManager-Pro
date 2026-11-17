import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'pdf_generator_helper.dart';

class EscPosHelper {
  /// Generate printable Arabic thermal receipt bytes using raster PDF pipeline.
  /// Solves the Arabic RTL shaping limitation of thermal ESC/POS printers by rasterizing the page.
  static Future<Uint8List> generateThermalArabicReceiptPdf({
    required VoucherCardData voucher,
    String networkName = 'MikroManager Pro',
    bool is80mm = false,
  }) async {
    return await PdfGeneratorHelper.generateThermalReceiptPdf(
      voucher: voucher,
      networkName: networkName,
      is80mm: is80mm,
    );
  }

  /// Generate ESC/POS receipt bytes for thermal printers (58mm or 80mm) in standard mode
  static Future<List<int>> generateThermalVoucher({
    required PaperSize paperSize,
    required String networkName,
    required String username,
    required String password,
    required String profile,
    required double price,
    String? validity,
    String? footerNote,
  }) async {
    final profileGenerator = await CapabilityProfile.load();
    final generator = Generator(paperSize, profileGenerator);
    final List<int> bytes = [];

    // Reset
    bytes.addAll(generator.reset());

    // Header / Network Name
    bytes.addAll(generator.text(
      networkName,
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        bold: true,
      ),
    ));

    bytes.addAll(generator.text(
      '--------------------------------',
      styles: const PosStyles(align: PosAlign.center),
    ));

    // Profile & Price
    bytes.addAll(generator.row([
      PosColumn(
        text: 'Profile: $profile',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: 'Price: ${price.toStringAsFixed(0)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]));

    if (validity != null) {
      bytes.addAll(generator.text(
        'Validity: $validity',
        styles: const PosStyles(align: PosAlign.center),
      ));
    }

    bytes.addAll(generator.text(
      '--------------------------------',
      styles: const PosStyles(align: PosAlign.center),
    ));

    // Credentials
    bytes.addAll(generator.text(
      'Username / Code:',
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.text(
      username,
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        bold: true,
      ),
    ));

    if (password != username && password.isNotEmpty) {
      bytes.addAll(generator.text(
        'Password: $password',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ));
    }

    // QR Code for quick login
    final qrData = 'http://login.hotspot/?username=$username&password=$password';
    bytes.addAll(generator.qrcode(qrData, size: QRSize.size4, align: PosAlign.center));

    // Footer
    bytes.addAll(generator.text(
      '--------------------------------',
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.text(
      footerNote ?? 'Thank you for choosing our service',
      styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontB),
    ));

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }
}
