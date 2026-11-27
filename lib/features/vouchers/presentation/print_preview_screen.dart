import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/pdf_generator_helper.dart';
import '../../routers/domain/routers_notifier.dart';
import '../data/pdf_archive_repository.dart';
import '../domain/vouchers_notifier.dart';
import 'template_gallery_screen.dart';

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
  VoucherTemplatesTableData? _selectedTemplate;
  bool _isCommitting = false;

  @override
  Widget build(BuildContext context) {
    final voucherState = ref.watch(vouchersControllerProvider);
    final templatesAsync = ref.watch(voucherTemplatesStreamProvider);
    final vouchers = voucherState.currentVouchers;

    templatesAsync.whenData((templates) {
      if (_selectedTemplate == null && templates.isNotEmpty) {
        _selectedTemplate = templates.firstWhere(
          (t) => t.isDefault,
          orElse: () => templates.first,
        );
      }
    });

    return PopScope(
      canPop: !voucherState.isDraft,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _confirmCancelDraft(context);
        if (shouldPop && context.mounted) {
          ref.read(vouchersControllerProvider.notifier).discardDraft();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(voucherState.isDraft
              ? 'معاينة المسودة قبل الاعتماد'
              : 'معاينة وطباعة الكروت'),
          actions: [
            if (vouchers.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.bookmark_add_outlined),
                tooltip: 'حفظ في أرشيف PDF',
                onPressed: () async {
                  final bytes = await _buildPdfData(vouchers);
                  final activeRouter =
                      ref.read(routersControllerProvider).activeRouter;
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
                    Icon(Icons.print_disabled_outlined,
                        size: 64,
                        color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text('لا توجد كروت جاهزة للطباعة حالياً',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    const Text(
                        'قم بتوليد دفعة جديدة أولاً من شاشة "توليد الكروت"',
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
                  // Draft Notice Banner
                  if (voucherState.isDraft)
                    Container(
                      color: AppColors.warning.withValues(alpha: 0.14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColors.warning, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'معاينة أولية (مسودة) - لم يتم إضافة الكروت إلى الراوتر بعد',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.warning,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'راجع شكل وتصميم الكروت وترتيبها، ثم اضغط على "اعتماد ورفع الكروت إلى الراوتر" في الأسفل.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Error Message Banner
                  if (voucherState.errorMessage != null)
                    Container(
                      color: AppColors.danger.withValues(alpha: 0.12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.danger, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              voucherState.errorMessage!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.danger,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Layout selector bar
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      children: [
                        const Text('تنسيق الطباعة:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: const Text('ورق A4 (شبكة)'),
                          selected: _selectedLayout == PrintLayoutType.a4Grid,
                          onSelected: (val) {
                            if (val) {
                              setState(() =>
                                  _selectedLayout = PrintLayoutType.a4Grid);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('حراري 58mm'),
                          selected: _selectedLayout == PrintLayoutType.thermal58,
                          onSelected: (val) {
                            if (val) {
                              setState(() =>
                                  _selectedLayout = PrintLayoutType.thermal58);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('حراري 80mm'),
                          selected: _selectedLayout == PrintLayoutType.thermal80,
                          onSelected: (val) {
                            if (val) {
                              setState(() =>
                                  _selectedLayout = PrintLayoutType.thermal80);
                            }
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
                      pdfFileName:
                          'Vouchers_MikroManager_${DateTime.now().millisecondsSinceEpoch}.pdf',
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: (voucherState.isDraft && vouchers.isNotEmpty)
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (voucherState.isUploading) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'جاري الرفع إلى الراوتر (${voucherState.uploadedCount} / ${voucherState.totalCount})...',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${(voucherState.uploadProgress * 100).toInt()}%',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.cyanAccent),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: voucherState.uploadProgress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.cyanAccent),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side: const BorderSide(color: AppColors.danger),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _isCommitting
                                  ? null
                                  : () async {
                                      final discard =
                                          await _confirmCancelDraft(context);
                                      if (discard && context.mounted) {
                                        ref
                                            .read(vouchersControllerProvider
                                                .notifier)
                                            .discardDraft();
                                        Navigator.pop(context);
                                      }
                                    },
                              icon: const Icon(Icons.close, size: 18),
                              label: const Text('إلغاء وتعديل',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed:
                                  _isCommitting ? null : () => _handleCommit(context),
                              icon: _isCommitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Icon(Icons.cloud_upload_outlined),
                              label: Text(
                                _isCommitting
                                    ? 'جاري الرفع والاعتماد...'
                                    : 'اعتماد ورفع الكروت إلى الراوتر',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Future<bool> _confirmCancelDraft(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('إلغاء المسودة؟'),
            content: const Text(
                'هل تريد بالتأكيد إلغاء هذه المسودة والعودة لشاشة التوليد؟\nلن يتم إضافة أي كروت إلى الراوتر.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('متابعة المعاينة'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('نعم، إلغاء المسودة'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _handleCommit(BuildContext context) async {
    setState(() => _isCommitting = true);
    final messenger = ScaffoldMessenger.of(context);
    final success =
        await ref.read(vouchersControllerProvider.notifier).commitDraftBatch();
    if (mounted) {
      setState(() => _isCommitting = false);
      if (success) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
                '🎉 تم اعتماد الكروت ورفعها إلى الراوتر بنجاح! يمكنك الآن الطباعة أو الحفظ.'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<Uint8List> _buildPdfData(List<VoucherCardData> vouchers) async {
    switch (_selectedLayout) {
      case PrintLayoutType.a4Grid:
        return await PdfGeneratorHelper.generateA4VouchersPdf(
          vouchers: vouchers,
          cardsPerRow: _selectedTemplate?.cardsPerRow ?? _cardsPerRow,
          cardsPerPage: _selectedTemplate?.cardsPerPage ?? _cardsPerPage,
          showQrCode: _selectedTemplate?.showQrCode ?? _showQrCode,
          template: _selectedTemplate,
        );
      case PrintLayoutType.thermal58:
        return await PdfGeneratorHelper.generateThermalReceiptPdf(
          voucher: vouchers.first,
          is80mm: false,
          template: _selectedTemplate,
        );
      case PrintLayoutType.thermal80:
        return await PdfGeneratorHelper.generateThermalReceiptPdf(
          voucher: vouchers.first,
          is80mm: true,
          template: _selectedTemplate,
        );
    }
  }

  void _showLayoutSettingsDialog(BuildContext context) {
    final templates =
        ref.read(voucherTemplatesStreamProvider).valueOrNull ?? [];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('إعدادات وقالب الطباعة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (templates.isNotEmpty) ...[
                  DropdownButtonFormField<VoucherTemplatesTableData>(
                    decoration: const InputDecoration(
                      labelText: 'اختر قالب التصميم',
                      prefixIcon: Icon(Icons.palette_outlined),
                    ),
                    value: _selectedTemplate,
                    items: templates.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(
                          '${t.name} (${t.paperSize})',
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          _selectedTemplate = val;
                          _cardsPerRow = val.cardsPerRow;
                          _cardsPerPage = val.cardsPerPage;
                          _showQrCode = val.showQrCode;
                        });
                        setState(() {
                          _selectedTemplate = val;
                          _cardsPerRow = val.cardsPerRow;
                          _cardsPerPage = val.cardsPerPage;
                          _showQrCode = val.showQrCode;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                DropdownButtonFormField<int>(
                  decoration:
                      const InputDecoration(labelText: 'عدد الكروت في كل صف'),
                  value: _cardsPerRow,
                  items: const [
                    DropdownMenuItem(
                        value: 2, child: Text('كرتان في الصف (2)')),
                    DropdownMenuItem(
                        value: 3, child: Text('3 كروت في الصف (مستحسن)')),
                    DropdownMenuItem(
                        value: 4, child: Text('4 كروت في الصف (4)')),
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
                  decoration: const InputDecoration(
                      labelText: 'إجمالي الكروت في الصفحة'),
                  value: _cardsPerPage,
                  items: const [
                    DropdownMenuItem(value: 8, child: Text('8 كروت بالصفحة')),
                    DropdownMenuItem(
                        value: 12, child: Text('12 كرت بالصفحة (مستحسن)')),
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
