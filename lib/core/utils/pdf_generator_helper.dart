// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../database/app_database.dart';

class VoucherCardData {
  final String username;
  final String password;
  final String profile;
  final double price;
  final String? validity;
  final String? networkName;
  final String? cardType;
  final bool isPrinted;

  VoucherCardData({
    required this.username,
    required this.password,
    required this.profile,
    required this.price,
    this.validity,
    this.networkName,
    this.cardType,
    this.isPrinted = false,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'profile': profile,
        'price': price,
        'validity': validity,
        'networkName': networkName,
        'cardType': cardType,
        'isPrinted': isPrinted,
      };

  factory VoucherCardData.fromJson(Map<String, dynamic> json) =>
      VoucherCardData(
        username: json['username'] as String? ?? '',
        password: json['password'] as String? ?? '',
        profile: json['profile'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        validity: json['validity'] as String?,
        networkName: json['networkName'] as String?,
        cardType: json['cardType'] as String?,
        isPrinted: json['isPrinted'] as bool? ?? false,
      );
}

class PdfGeneratorHelper {
  static PdfColor _resolveColor(dynamic colorValue, PdfColor fallback) {
    if (colorValue == null) return fallback;
    if (colorValue is int) return PdfColor.fromInt(colorValue);
    if (colorValue is String) {
      var clean = colorValue.replaceAll('#', '').trim();
      if (clean.length == 6) clean = 'FF$clean';
      final val = int.tryParse(clean, radix: 16);
      if (val != null) return PdfColor.fromInt(val);
    }
    return fallback;
  }

  /// Generate A4 Grid PDF for vouchers batch with customizable template
  static Future<Uint8List> generateA4VouchersPdf({
    required List<VoucherCardData> vouchers,
    String networkName = 'MikroManager Pro',
    int cardsPerRow = 3,
    int cardsPerPage = 12,
    bool showQrCode = true,
    VoucherTemplatesTableData? template,
  }) async {
    final pdf = pw.Document();

    final effectiveCardsPerRow = template?.cardsPerRow ?? cardsPerRow;
    final effectiveCardsPerPage = template?.cardsPerPage ?? cardsPerPage;
    final marginMm = template?.marginMm ?? 8.0;

    // Chunk into pages
    for (int i = 0; i < vouchers.length; i += effectiveCardsPerPage) {
      final pageVouchers = vouchers.sublist(
        i,
        (i + effectiveCardsPerPage < vouchers.length)
            ? i + effectiveCardsPerPage
            : vouchers.length,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(marginMm * PdfPageFormat.mm),
          build: (pw.Context context) {
            return pw.GridView(
              crossAxisCount: effectiveCardsPerRow,
              childAspectRatio: 0.82,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: pageVouchers.map((v) {
                return _buildVoucherCard(v, networkName, showQrCode, template);
              }).toList(),
            );
          },
        ),
      );
    }

    return await pdf.save();
  }

  static pw.Widget _buildVoucherCard(
    VoucherCardData voucher,
    String defaultNetworkName,
    bool defaultShowQr,
    VoucherTemplatesTableData? template,
  ) {
    final netName = template?.headerText?.isNotEmpty == true
        ? template!.headerText!
        : (voucher.networkName ?? defaultNetworkName);

    final showQr = template?.showQrCode ?? defaultShowQr;
    final showBarcode = template?.showBarcode ?? false;
    final showProfile = template?.showProfile ?? true;
    final showPrice = template?.showPrice ?? true;
    final showValidity = template?.showValidity ?? true;
    final showUser = template?.showUsername ?? true;
    final showPass = template?.showPassword ?? true;
    final showInstructions = template?.showInstructions ?? false;

    final bgColor =
        _resolveColor(template?.backgroundColorHex, PdfColors.white);
    final textColor = _resolveColor(template?.textColorHex, PdfColors.black);
    final titleColor = _resolveColor(template?.titleColorHex, PdfColors.white);
    final borderColor =
        _resolveColor(template?.borderColorHex, PdfColors.blueGrey800);
    final headerBgColor =
        _resolveColor(template?.primaryColorHex, PdfColors.blueGrey900);

    final borderWidth = template?.borderWidth ?? 1.5;
    final borderRadius = template?.borderRadius ?? 8.0;
    final fontSize = template?.fontSize ?? 10.0;
    final titleFontSize = template?.titleFontSize ?? 11.0;

    final qrData =
        'http://login.hotspot/?user=${voucher.username}&pass=${voucher.password}';

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: bgColor,
        border: pw.Border.all(color: borderColor, width: borderWidth),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(borderRadius)),
      ),
      padding: const pw.EdgeInsets.all(6),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Header Bar
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: pw.BoxDecoration(
              color: headerBgColor,
              borderRadius: pw.BorderRadius.all(
                  pw.Radius.circular(borderRadius > 4 ? borderRadius - 2 : 4)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    netName,
                    style: pw.TextStyle(
                      color: titleColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
                    maxLines: 1,
                  ),
                ),
                if (showProfile)
                  pw.Text(
                    voucher.profile,
                    style: pw.TextStyle(
                      color: PdfColors.lightBlue200,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: fontSize * 0.85,
                    ),
                  ),
              ],
            ),
          ),
          pw.SizedBox(height: 3),

          // QR / Barcode & Price Row
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (showQr)
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: qrData,
                  width: 44,
                  height: 44,
                ),
              if (showQr && (showPrice || showValidity)) pw.SizedBox(width: 8),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  if (showPrice)
                    pw.Text(
                      '${voucher.price.toStringAsFixed(0)} YER',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize + 1,
                        color: PdfColors.teal800,
                      ),
                    ),
                  if (showValidity && voucher.validity != null)
                    pw.Text(
                      voucher.validity!,
                      style: pw.TextStyle(
                        fontSize: fontSize * 0.8,
                        color: PdfColors.grey700,
                      ),
                    ),
                ],
              ),
            ],
          ),

          if (showBarcode) ...[
            pw.SizedBox(height: 3),
            pw.BarcodeWidget(
              barcode: pw.Barcode.code128(),
              data: voucher.username,
              width: 100,
              height: 20,
              drawText: false,
            ),
          ],

          pw.SizedBox(height: 3),

          // Code & Credentials Box
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border.all(color: PdfColors.grey400, width: 0.8),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Column(
              children: [
                if (showUser)
                  pw.Text(
                    'Code: ${voucher.username}',
                    style: pw.TextStyle(
                      color: textColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: fontSize + 1,
                      letterSpacing: 1.1,
                    ),
                  ),
                if (showPass &&
                    voucher.password != voucher.username &&
                    voucher.password.isNotEmpty)
                  pw.Text(
                    'Pass: ${voucher.password}',
                    style: pw.TextStyle(
                      fontSize: fontSize * 0.85,
                      color: textColor,
                    ),
                  ),
              ],
            ),
          ),

          // Instructions / Footer if configured
          if (showInstructions &&
              (template?.instructionsText != null ||
                  template?.footerText != null ||
                  template?.contactPhone != null)) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              template?.instructionsText ??
                  template?.footerText ??
                  (template?.contactPhone != null
                      ? 'الدعم: ${template!.contactPhone}'
                      : ''),
              style: pw.TextStyle(
                fontSize: 6.5,
                color: PdfColors.grey700,
              ),
              maxLines: 1,
              textAlign: pw.TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Generate Single Thermal Receipt PDF (58mm or 80mm format)
  static Future<Uint8List> generateThermalReceiptPdf({
    required VoucherCardData voucher,
    String networkName = 'MikroManager Pro',
    bool is80mm = false,
    VoucherTemplatesTableData? template,
  }) async {
    final pdf = pw.Document();
    final width = is80mm ? 72.0 * PdfPageFormat.mm : 54.0 * PdfPageFormat.mm;

    final headerText = template?.headerText?.isNotEmpty == true
        ? template!.headerText!
        : networkName;
    final footerText = template?.footerText ??
        template?.instructionsText ??
        (template?.contactPhone != null
            ? 'الدعم الفني: ${template!.contactPhone}'
            : 'شكراً لاستخدامكم شبكتنا!');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(width, 110 * PdfPageFormat.mm),
        margin: const pw.EdgeInsets.all(5),
        build: (pw.Context context) {
          final qrData =
              'http://login.hotspot/?user=${voucher.username}&pass=${voucher.password}';
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                headerText,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Profile: ${voucher.profile}',
                      style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('${voucher.price.toStringAsFixed(0)} YER',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9)),
                ],
              ),
              if (voucher.validity != null) ...[
                pw.SizedBox(height: 2),
                pw.Text('Validity: ${voucher.validity}',
                    style: const pw.TextStyle(fontSize: 8)),
              ],
              pw.SizedBox(height: 6),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: qrData,
                width: 44,
                height: 44,
              ),
              pw.SizedBox(height: 6),
              pw.Text('Code / Voucher:',
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(voucher.username,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 13)),
              if (voucher.password != voucher.username &&
                  voucher.password.isNotEmpty)
                pw.Text('Pass: ${voucher.password}',
                    style: const pw.TextStyle(fontSize: 9)),
              pw.Divider(thickness: 0.5),
              pw.Text(
                footerText,
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );

    return await pdf.save();
  }
}
