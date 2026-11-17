import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/pdf_generator_helper.dart';
import '../../routers/domain/routers_notifier.dart';
import '../data/pdf_archive_repository.dart';
import '../domain/vouchers_notifier.dart';

enum PrintLayoutType { a4Grid, thermal58, thermal80 }

class PrintPreviewScreen extends ConsumerStatefulWidget {
  const PrintPreviewScreen({super.key});

  @override
  ConsumerState<PrintPreviewScreen> createState() => _PrintPreviewScreenState();
}

class _PrintPreviewScreenState extends ConsumerState<PrintPreviewScreen> {
  PrintLayoutType _selectedLayout = PrintLayoutType.a4Grid;
  int _cardsPerRow = 3;
  int _cardsPerPage = 12;
  bool _showQrCode = true;

  @override
  Widget build(BuildContext context) {
    final voucherState = ref.watch(vouchersControllerProvider);
    final vouchers = voucherState.currentVouchers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة وطباعة الكروت'),
        actions: [
          if (vouchers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              tooltip: 'حفظ في أرشيف PDF',
              onPressed: () async {
                final bytes = await _buildPdfData(vouchers);
                final activeRouter = ref.read(routersControllerProvider).activeRouter;
                final connectionId = activeRouter?.id ?? 1;
                final batchName = vouchers.first.profile;
                await ref.read(pdfArchiveRepositoryProvider).saveToArchive(
                      connectionId: connectionId,
                      batchId: batchName,
                      pdfBytes: bytes,
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حفظ ملف PDF في الأرشيف بنجاح!'),
                      backgroundColor: AppColors.success,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.folder_zip_outlined),
            tooltip: 'أرشيف PDF',
            onPressed: () => context.push('/pdf-archive'),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'خيارات التخطيط',
            onPressed: () => _showLayoutSettingsDialog(context),
          ),
        ],
      ),
      body: vouchers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.print_disabled_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('لا توجد كروت جاهزة للطباعة حالياً',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const Text('قم بتوليد دفعة جديدة أولاً من شاشة "توليد الكروت"',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('العودة لتوليد الكروت'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Layout selector bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Text('تنسيق الطباعة:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text('ورق A4 (شبكة)'),
                        selected: _selectedLayout == PrintLayoutType.a4Grid,
                        onSelected: (val) {
                          if (val) setState(() => _selectedLayout = PrintLayoutType.a4Grid);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('حراري 58mm'),
                        selected: _selectedLayout == PrintLayoutType.thermal58,
                        onSelected: (val) {
                          if (val) setState(() => _selectedLayout = PrintLayoutType.thermal58);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('حراري 80mm'),
                        selected: _selectedLayout == PrintLayoutType.thermal80,
                        onSelected: (val) {
                          if (val) setState(() => _selectedLayout = PrintLayoutType.thermal80);
                        },
                      ),
                    ],
                  ),
                ),
                // PDF Viewer
                Expanded(
                  child: PdfPreview(
                    build: (format) => _buildPdfData(vouchers),
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    allowPrinting: true,
                    allowSharing: true,
                    pdfFileName: 'Vouchers_MikroManager_${DateTime.now().millisecondsSinceEpoch}.pdf',
                  ),
                ),
              ],
            ),
    );
  }

  Future<Uint8List> _buildPdfData(List<VoucherCardData> vouchers) async {
    switch (_selectedLayout) {
      case PrintLayoutType.a4Grid:
        return await PdfGeneratorHelper.generateA4VouchersPdf(
          vouchers: vouchers,
          cardsPerRow: _cardsPerRow,
          cardsPerPage: _cardsPerPage,
          showQrCode: _showQrCode,
        );
      case PrintLayoutType.thermal58:
        return await PdfGeneratorHelper.generateThermalReceiptPdf(
          voucher: vouchers.first,
          is80mm: false,
        );
      case PrintLayoutType.thermal80:
        return await PdfGeneratorHelper.generateThermalReceiptPdf(
          voucher: vouchers.first,
          is80mm: true,
        );
    }
  }

  void _showLayoutSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('إعدادات تخطيط A4'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'عدد الكروت في كل صف'),
                value: _cardsPerRow,
                items: const [
                  DropdownMenuItem(value: 2, child: Text('كرتان في الصف (2)')),
                  DropdownMenuItem(value: 3, child: Text('3 كروت في الصف (مستحسن)')),
                  DropdownMenuItem(value: 4, child: Text('4 كروت في الصف (4)')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() => _cardsPerRow = val);
                    setState(() => _cardsPerRow = val);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'إجمالي الكروت في الصفحة'),
                value: _cardsPerPage,
                items: const [
                  DropdownMenuItem(value: 8, child: Text('8 كروت بالصفحة')),
                  DropdownMenuItem(value: 12, child: Text('12 كرت بالصفحة (مستحسن)')),
                  DropdownMenuItem(value: 15, child: Text('15 كرت بالصفحة')),
                  DropdownMenuItem(value: 18, child: Text('18 كرت بالصفحة')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() => _cardsPerPage = val);
                    setState(() => _cardsPerPage = val);
                  }
                },
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('إظهار رمز الاستجابة السريعة (QR Code)'),
                value: _showQrCode,
                onChanged: (val) {
                  setDialogState(() => _showQrCode = val ?? true);
                  setState(() => _showQrCode = val ?? true);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إغلاق وتطبيق'),
            ),
          ],
        ),
      ),
    );
  }
}
