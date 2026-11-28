// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
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
  final String? serialNumber;
  final bool isPrinted;

  VoucherCardData({
    required this.username,
    required this.password,
    required this.profile,
    required this.price,
    this.validity,
    this.networkName,
    this.cardType,
    this.serialNumber,
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
        'serialNumber': serialNumber,
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
        serialNumber: json['serialNumber'] as String?,
        isPrinted: json['isPrinted'] as bool? ?? false,
      );
}

class PdfGeneratorHelper {
  static pw.Font? _cachedRegularFont;
  static pw.Font? _cachedBoldFont;
  static Uint8List? _cachedRegularBytes;
  static Uint8List? _cachedBoldBytes;

  /// Loads and caches Cairo font for Arabic PDF generation
  static Future<void> ensureFontsLoaded() async {
    if (_cachedRegularFont != null && _cachedBoldFont != null) return;
    try {
      final regData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
      _cachedRegularBytes = regData.buffer.asUint8List();
      _cachedRegularFont = pw.Font.ttf(regData);
    } catch (_) {
      try {
        final f = File('assets/fonts/Cairo-Regular.ttf');
        if (f.existsSync()) {
          final b = f.readAsBytesSync();
          _cachedRegularBytes = b;
          _cachedRegularFont = pw.Font.ttf(b.buffer.asByteData());
        }
      } catch (_) {}
    }

    try {
      final boldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
      _cachedBoldBytes = boldData.buffer.asUint8List();
      _cachedBoldFont = pw.Font.ttf(boldData);
    } catch (_) {
      try {
        final f = File('assets/fonts/Cairo-Bold.ttf');
        if (f.existsSync()) {
          final b = f.readAsBytesSync();
          _cachedBoldBytes = b;
          _cachedBoldFont = pw.Font.ttf(b.buffer.asByteData());
        }
      } catch (_) {}
    }
  }

  static pw.ThemeData _resolveTheme() {
    if (_cachedRegularFont != null && _cachedBoldFont != null) {
      return pw.ThemeData.withFont(
        base: _cachedRegularFont!,
        bold: _cachedBoldFont!,
      );
    } else if (_cachedRegularFont != null) {
      return pw.ThemeData.withFont(base: _cachedRegularFont!);
    }
    return pw.ThemeData();
  }

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
    bool showPageNumbers = true,
    String? batchName,
    VoucherTemplatesTableData? template,
    Uint8List? bgImageBytes,
  }) async {
    await ensureFontsLoaded();

    final regBytes = _cachedRegularBytes;
    final boldBytes = _cachedBoldBytes;

    if (regBytes != null && vouchers.length >= 30) {
      try {
        return await Isolate.run(() async {
          final regularFont = pw.Font.ttf(ByteData.view(regBytes.buffer));
          final boldFont = boldBytes != null
              ? pw.Font.ttf(ByteData.view(boldBytes.buffer))
              : null;
          return await _buildA4PdfSync(
            vouchers: vouchers,
            networkName: networkName,
            cardsPerRow: cardsPerRow,
            cardsPerPage: cardsPerPage,
            showQrCode: showQrCode,
            showPageNumbers: showPageNumbers,
            batchName: batchName,
            template: template,
            bgImageBytes: bgImageBytes,
            regularFont: regularFont,
            boldFont: boldFont,
          );
        });
      } catch (_) {
        // Fallback to current thread if isolate fails
      }
    }

    return await _buildA4PdfSync(
      vouchers: vouchers,
      networkName: networkName,
      cardsPerRow: cardsPerRow,
      cardsPerPage: cardsPerPage,
      showQrCode: showQrCode,
      showPageNumbers: showPageNumbers,
      batchName: batchName,
      template: template,
      bgImageBytes: bgImageBytes,
      regularFont: _cachedRegularFont,
      boldFont: _cachedBoldFont,
    );
  }

  static Future<Uint8List> _buildA4PdfSync({
    required List<VoucherCardData> vouchers,
    required String networkName,
    required int cardsPerRow,
    required int cardsPerPage,
    required bool showQrCode,
    required bool showPageNumbers,
    String? batchName,
    VoucherTemplatesTableData? template,
    Uint8List? bgImageBytes,
    pw.Font? regularFont,
    pw.Font? boldFont,
  }) async {
    final theme = (regularFont != null && boldFont != null)
        ? pw.ThemeData.withFont(base: regularFont, bold: boldFont)
        : (regularFont != null
            ? pw.ThemeData.withFont(base: regularFont)
            : pw.ThemeData());
    final pdf = pw.Document(theme: theme);

    final effectiveCardsPerRow = template?.cardsPerRow ?? cardsPerRow;
    final effectiveCardsPerPage = template?.cardsPerPage ?? cardsPerPage;
    final marginMm = template?.marginMm ?? 8.0;

    // Cache background image once for memory efficiency
    pw.MemoryImage? cachedBgImage;
    if (bgImageBytes != null && bgImageBytes.isNotEmpty) {
      cachedBgImage = pw.MemoryImage(bgImageBytes);
    } else if (template?.logoPath != null && template!.logoPath!.isNotEmpty) {
      try {
        final f = File(template.logoPath!);
        if (f.existsSync()) {
          cachedBgImage = pw.MemoryImage(f.readAsBytesSync());
        }
      } catch (_) {}
    }

    final totalPages = (vouchers.length / effectiveCardsPerPage).ceil();

    // Chunk into pages
    int pageIndex = 0;
    for (int i = 0; i < vouchers.length; i += effectiveCardsPerPage) {
      pageIndex++;
      final currentPage = pageIndex;
      final pageVouchers = vouchers.sublist(
        i,
        (i + effectiveCardsPerPage < vouchers.length)
            ? i + effectiveCardsPerPage
            : vouchers.length,
      );

      final startSerial = pageVouchers.first.serialNumber;
      final endSerial = pageVouchers.last.serialNumber;
      final serialRange = (startSerial != null && endSerial != null)
          ? '$startSerial - $endSerial'
          : null;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(marginMm * PdfPageFormat.mm),
          textDirection: pw.TextDirection.rtl,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                if (batchName != null || serialRange != null) ...[
                  pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 6),
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 2, horizontal: 4),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                            color: PdfColors.grey400, width: 0.5),
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (batchName != null)
                          pw.Text(
                            batchName,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey700,
                            ),
                          ),
                        if (serialRange != null)
                          pw.Text(
                            'الأرقام: $serialRange',
                            style: pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                pw.Expanded(
                  child: pw.GridView(
                    crossAxisCount: effectiveCardsPerRow,
                    childAspectRatio: 0.82,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: pageVouchers.map((v) {
                      return _buildVoucherCard(
                          v, networkName, showQrCode, template, cachedBgImage);
                    }).toList(),
                  ),
                ),
                if (showPageNumbers) ...[
                  pw.Container(
                    alignment: pw.Alignment.center,
                    margin: const pw.EdgeInsets.only(top: 4),
                    child: pw.Text(
                      'صفحة $currentPage من $totalPages',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ],
              ],
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
    pw.MemoryImage? bgImage,
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

    // Check if custom positioned template elements exist in configJson
    if (template?.configJson != null && template!.configJson!.isNotEmpty) {
      try {
        final decoded =
            jsonDecode(template.configJson!) as Map<String, dynamic>;
        final elements = decoded['elements'] as Map<String, dynamic>?;
        if (elements != null && elements.isNotEmpty) {
          return _buildCustomPositionedCard(
              voucher, template, bgImage, elements);
        }
      } catch (_) {}
    }

    final qrData =
        'http://login.hotspot/?user=${voucher.username}&pass=${voucher.password}';

    final cardContent = pw.Column(
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
                if (voucher.serialNumber != null &&
                    voucher.serialNumber!.isNotEmpty)
                  pw.Text(
                    'SN: ${voucher.serialNumber}',
                    style: pw.TextStyle(
                      fontSize: fontSize * 0.7,
                      color: PdfColors.grey600,
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
    );

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: bgColor,
        image: bgImage != null
            ? pw.DecorationImage(
                image: bgImage,
                fit: pw.BoxFit.cover,
              )
            : null,
        border: pw.Border.all(color: borderColor, width: borderWidth),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(borderRadius)),
      ),
      padding: const pw.EdgeInsets.all(6),
      child: cardContent,
    );
  }

  static pw.Widget _buildCustomPositionedCard(
    VoucherCardData voucher,
    VoucherTemplatesTableData? template,
    pw.MemoryImage? bgImage,
    Map<String, dynamic> elements,
  ) {
    final bgColor =
        _resolveColor(template?.backgroundColorHex, PdfColors.white);
    final borderColor =
        _resolveColor(template?.borderColorHex, PdfColors.blueGrey800);
    final borderWidth = template?.borderWidth ?? 1.5;
    final borderRadius = template?.borderRadius ?? 8.0;

    final children = <pw.Widget>[];

    for (final entry in elements.entries) {
      final key = entry.key;
      final el = entry.value as Map<String, dynamic>;
      final isVisible = el['isVisible'] as bool? ?? true;
      if (!isVisible) continue;

      final xPercent = (el['xPercent'] as num?)?.toDouble() ?? 0.5;
      final yPercent = (el['yPercent'] as num?)?.toDouble() ?? 0.5;
      final fontSize = (el['fontSize'] as num?)?.toDouble() ?? 12.0;
      final isBold = el['isBold'] as bool? ?? false;
      final isMonospace = el['isMonospace'] as bool? ?? false;
      final colorHex = el['colorHex'];
      final textColor = _resolveColor(colorHex, PdfColors.black);
      final showPill = el['showBackgroundPill'] as bool? ?? false;
      final pillColor = _resolveColor(el['pillColorHex'], PdfColors.white);

      String text = '';
      switch (key) {
        case 'networkName':
          text = template?.headerText?.isNotEmpty == true
              ? template!.headerText!
              : (voucher.networkName ?? 'MikroManager');
          break;
        case 'profile':
          text = voucher.profile;
          break;
        case 'price':
          text = '${voucher.price.toStringAsFixed(0)} YER';
          break;
        case 'code':
          text = voucher.username;
          break;
        case 'password':
          if (voucher.password.isNotEmpty &&
              voucher.password != voucher.username) {
            text = 'Pass: ${voucher.password}';
          }
          break;
        case 'serial':
          if (voucher.serialNumber != null &&
              voucher.serialNumber!.isNotEmpty) {
            text = 'SN: ${voucher.serialNumber}';
          }
          break;
      }

      if (text.isEmpty) continue;

      pw.Widget textWidget = pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize * 0.85,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          font: isMonospace ? pw.Font.courier() : null,
          color: textColor,
        ),
      );

      if (showPill) {
        textWidget = pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: pw.BoxDecoration(
            color: pillColor,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: textWidget,
        );
      }

      children.add(
        pw.Positioned(
          left: (xPercent * 165).clamp(0.0, 150.0),
          top: (yPercent * 135).clamp(0.0, 120.0),
          child: textWidget,
        ),
      );
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: bgColor,
        image: bgImage != null
            ? pw.DecorationImage(image: bgImage, fit: pw.BoxFit.cover)
            : null,
        border: pw.Border.all(color: borderColor, width: borderWidth),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(borderRadius)),
      ),
      child: pw.Stack(children: children),
    );
  }

  /// Generate Single Thermal Receipt PDF (58mm or 80mm format)
  static Future<Uint8List> generateThermalReceiptPdf({
    required VoucherCardData voucher,
    String networkName = 'MikroManager Pro',
    bool is80mm = false,
    VoucherTemplatesTableData? template,
  }) async {
    await ensureFontsLoaded();
    final theme = _resolveTheme();
    final pdf = pw.Document(theme: theme);
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
        textDirection: pw.TextDirection.rtl,
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
              if (voucher.serialNumber != null &&
                  voucher.serialNumber!.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text('SN: ${voucher.serialNumber}',
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
