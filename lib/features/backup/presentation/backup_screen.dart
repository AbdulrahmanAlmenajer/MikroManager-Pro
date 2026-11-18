import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/session/session_controller.dart';
import '../domain/backup_notifier.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(backupNotifierProvider);
    final session = ref.watch(sessionControllerProvider).session;
    final connectionId = session?.connectionId ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي والاستعادة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث السجل',
            onPressed: () => ref
                .read(backupNotifierProvider.notifier)
                .loadHistory(connectionId),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status/Success/Error Banners
            if (state.isProcessing)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cyanAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 12),
                    Text('جاري معالجة النسخة الاحتياطية...'),
                  ],
                ),
              ),

            if (state.lastSuccessMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.success),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(state.lastSuccessMessage!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ),

            if (state.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.danger),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(state.errorMessage!,
                          style: const TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),

            // Card 1: App Data Backup & Restore
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.phone_android, color: AppColors.cyanAccent),
                        SizedBox(width: 8),
                        Text('بيانات التطبيق (App Data)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'يشمل حفظ الكروت المنشأة، القوالب، تسعير الفئات، التحصيلات المالية، وأجهزة البث مع فحص سلامة SHA-256.',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cyanAccent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: state.isProcessing
                                ? null
                                : () async {
                                    final res = await ref
                                        .read(backupNotifierProvider.notifier)
                                        .exportAppData(connectionId);
                                    if (res.isSuccess) {
                                      final file = File(res.path);
                                      if (await file.exists()) {
                                        final bytes = await file.readAsBytes();
                                        await Printing.sharePdf(
                                          bytes: bytes,
                                          filename: file.uri.pathSegments.last,
                                        );
                                      }
                                    }
                                  },
                            icon: const Icon(Icons.upload_file),
                            label: const Text('تصدير ومشاركة'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.isProcessing
                                ? null
                                : () =>
                                    _showRestoreDialog(context, connectionId),
                            icon: const Icon(Icons.download),
                            label: const Text('استعادة البيانات'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card 2: RouterOS Backup
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.router_outlined, color: AppColors.success),
                        SizedBox(width: 8),
                        Text('نسخ إعدادات الراوتر (RouterOS)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'طلب إنشاء ملف نسخة احتياطية وحفظه في ذاكرة الراوتر (Files) للرجوع إليه وقت الطوارئ.',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cardBackground,
                              foregroundColor: AppColors.success,
                            ),
                            onPressed: session == null || state.isProcessing
                                ? null
                                : () => ref
                                    .read(backupNotifierProvider.notifier)
                                    .backupRouter(session.adapter, connectionId,
                                        isScriptExport: false),
                            icon: const Icon(Icons.save_as),
                            label: const Text('نسخة كاملة (.backup)'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cardBackground,
                              foregroundColor: AppColors.cyanAccent,
                            ),
                            onPressed: session == null || state.isProcessing
                                ? null
                                : () => ref
                                    .read(backupNotifierProvider.notifier)
                                    .backupRouter(session.adapter, connectionId,
                                        isScriptExport: true),
                            icon: const Icon(Icons.code),
                            label: const Text('تصدير سكربت (.rsc)'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section 3: Backup History Log
            const Text('سجل النسخ الاحتياطية المسجلة:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),

            if (state.history.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('لا توجد سجلات نسخ سابقة.',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.history.length,
                itemBuilder: (context, idx) {
                  final log = state.history[idx];
                  IconData icon;
                  Color iconColor;
                  String kindTitle;

                  switch (log.kind) {
                    case 'app_data':
                      icon = Icons.phone_android;
                      iconColor = AppColors.cyanAccent;
                      kindTitle = 'نسخة التطبيق';
                      break;
                    case 'router_backup':
                      icon = Icons.router;
                      iconColor = AppColors.success;
                      kindTitle = 'نسخة راوتر ثنائية';
                      break;
                    case 'router_rsc':
                      icon = Icons.code;
                      iconColor = Colors.orange;
                      kindTitle = 'سكربت راوتر';
                      break;
                    default:
                      icon = Icons.inventory;
                      iconColor = AppColors.textSecondary;
                      kindTitle = log.kind;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: iconColor.withValues(alpha: 0.15),
                        child: Icon(icon, color: iconColor),
                      ),
                      title: Text(log.path.split(Platform.pathSeparator).last,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text(
                        '$kindTitle  •  ${DateFormat('yyyy/MM/dd HH:mm').format(log.createdAt)}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.danger, size: 20),
                        tooltip: 'حذف السجل',
                        onPressed: () => ref
                            .read(backupNotifierProvider.notifier)
                            .deleteHistoryItem(log.id, connectionId),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, int connectionId) {
    final textCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('استعادة نسخة احتياطية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الصق محتوى ملف النسخة الاحتياطية (JSON) هنا لاستعادة البيانات:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textCtrl,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: '{"checksum": "...", "data": {...}}',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final content = textCtrl.text.trim();
              if (content.isNotEmpty) {
                final messenger = ScaffoldMessenger.of(context);
                final ok = await ref
                    .read(backupNotifierProvider.notifier)
                    .restoreAppData(connectionId, content);
                if (ctx.mounted) Navigator.pop(ctx);
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(ok
                          ? '✅ تمت استعادة البيانات بنجاح!'
                          : '❌ فشل الاستعادة، الملف تالف أو غير صالح.'),
                      backgroundColor:
                          ok ? AppColors.success : AppColors.danger,
                    ),
                  );
                }
              }
            },
            child: const Text('بدء الاستعادة'),
          ),
        ],
      ),
    );
  }
}
