import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../routers/domain/routers_notifier.dart';
import '../data/pdf_archive_repository.dart';

class PdfArchiveScreen extends ConsumerWidget {
  const PdfArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRouter = ref.watch(routersControllerProvider).activeRouter;
    final connectionId = activeRouter?.id ?? 1;
    final repo = ref.watch(pdfArchiveRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('أرشيف ملفات PDF المولدة'),
      ),
      body: StreamBuilder<List<PdfArchiveTableData>>(
        stream: repo.watchArchivedPdfs(connectionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ في تحميل الأرشيف: ${snapshot.error}'));
          }

          final archives = snapshot.data ?? [];
          if (archives.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_zip_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'أرشيف PDF فارغ حالياً',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'عند تصدير أو طباعة دفعات الكروت يتم أرشفة ملفات PDF هنا تلقائياً لإعادة طباعتها بأي وقت',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          final dateFormat = DateFormat('yyyy/MM/dd - hh:mm a');

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: archives.length,
            itemBuilder: (context, index) {
              final item = archives[index];
              final file = File(item.filePath);
              final exists = file.existsSync();
              final sizeInKb = exists ? (file.lengthSync() / 1024).toStringAsFixed(1) : '0';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.cyanAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.picture_as_pdf, color: AppColors.cyanAccent, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'دفعة: ${item.batchId}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateFormat.format(item.createdAt),
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'الحجم: $sizeInKb KB | الحالة: ${exists ? 'جاهز' : 'الملف مفقود'}',
                              style: TextStyle(fontSize: 11, color: exists ? AppColors.navyPrimary : AppColors.danger),
                            ),
                          ],
                        ),
                      ),
                      if (exists)
                        IconButton(
                          icon: const Icon(Icons.print, color: AppColors.cyanAccent),
                          tooltip: 'إعادة الطباعة',
                          onPressed: () async {
                            final bytes = await file.readAsBytes();
                            await Printing.layoutPdf(
                              onLayout: (_) => bytes,
                              name: 'reprint_${item.batchId}.pdf',
                            );
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                        tooltip: 'حذف من الأرشيف',
                        onPressed: () => _confirmDelete(context, repo, item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, PdfArchiveRepository repo, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد حذف الملف من الأرشيف'),
        content: const Text('هل أنت متأكد من حذف هذا الملف نهائياً من الأرشيف المحلي؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              await repo.deleteArchive(id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
