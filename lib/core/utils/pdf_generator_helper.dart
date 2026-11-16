// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class VoucherCardData {
  final String username;
  final String password;
  final String profile;
  final double price;
  final String? validity;
  final String? networkName;

  VoucherCardData({
    required this.username,
    required this.password,
    required this.profile,
    required this.price,
    this.validity,
    this.networkName,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'profile': profile,
        'price': price,
        'validity': validity,
        'networkName': networkName,
      };

  factory VoucherCardData.fromJson(Map<String, dynamic> json) => VoucherCardData(
        username: json['username'] as String? ?? '',
        password: json['password'] as String? ?? '',
        profile: json['profile'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        validity: json['validity'] as String?,
        networkName: json['networkName'] as String?,
      );
}

class PdfGeneratorHelper {
  /// Generate A4 Grid PDF for vouchers batch
  static Future<Uint8List> generateA4VouchersPdf({
    required List<VoucherCardData> vouchers,
    String networkName = 'MikroManager Pro',
    int cardsPerRow = 3,
    int cardsPerPage = 12,
    bool showQrCode = true,
  }) async {
    final pdf = pw.Document();

    // Chunk into pages
    for (int i = 0; i < vouchers.length; i += cardsPerPage) {
      final pageVouchers = vouchers.sublist(
        i,
        (i + cardsPerPage < vouchers.length) ? i + cardsPerPage : vouchers.length,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(16),
          build: (pw.Context context) {
            return pw.GridView(
              crossAxisCount: cardsPerRow,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: pageVouchers.map((v) {
                return _buildVoucherCard(v, networkName, showQrCode);
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
    bool showQrCode,
  ) {
    final netName = voucher.networkName ?? defaultNetworkName;
    final qrData = 'http://login.hotspot/?user=${voucher.username}&pass=${voucher.password}';

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blueGrey800, width: 1.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: const pw.BoxDecoration(
              color: PdfColors.blueGrey900,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  netName,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
                pw.Text(
                  voucher.profile,
                  style: pw.TextStyle(
                    color: PdfColors.lightBlue200,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 4),

          // QR Code & Price
          if (showQrCode)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: qrData,
                  width: 50,
                  height: 50,
                ),
                pw.SizedBox(width: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Price: ${voucher.price.toStringAsFixed(0)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.teal800),
                    ),
                    if (voucher.validity != null)
                      pw.Text(
                        voucher.validity!,
                        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                      ),
                  ],
                ),
              ],
            ),

          pw.SizedBox(height: 4),

          // Code
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Column(
              children: [
                pw.Text(
                  'Code: ${voucher.username}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
                if (voucher.password != voucher.username && voucher.password.isNotEmpty)
                  pw.Text(
                    'Pass: ${voucher.password}',
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Generate Single Thermal Receipt PDF (58mm or 80mm format)
  static Future<Uint8List> generateThermalReceiptPdf({
    required VoucherCardData voucher,
    String networkName = 'MikroManager Pro',
    bool is80mm = false,
  }) async {
    final pdf = pw.Document();
    final width = is80mm ? 72.0 * PdfPageFormat.mm : 54.0 * PdfPageFormat.mm;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(width, 100 * PdfPageFormat.mm),
        margin: const pw.EdgeInsets.all(6),
        build: (pw.Context context) {
          final qrData = 'http://login.hotspot/?user=${voucher.username}&pass=${voucher.password}';
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(networkName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Profile: ${voucher.profile}', style: const pw.TextStyle(fontSize: 9)),
                  pw.Text('Price: ${voucher.price.toStringAsFixed(0)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: qrData, width: 44, height: 44),
              pw.SizedBox(height: 6),
              pw.Text('Code / Voucher:', style: const pw.TextStyle(fontSize: 8)),
              pw.Text(voucher.username, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              if (voucher.password != voucher.username && voucher.password.isNotEmpty)
                pw.Text('Pass: ${voucher.password}', style: const pw.TextStyle(fontSize: 9)),
              pw.Divider(thickness: 0.5),
              pw.Text('Thank you!', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
            ],
          );
        },
      ),
    );

    return await pdf.save();
  }
}
