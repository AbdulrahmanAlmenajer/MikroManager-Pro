import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../domain/um_diagnostic_notifier.dart';

class UmDiagnosticScreen extends ConsumerWidget {
  const UmDiagnosticScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(umDiagnosticControllerProvider);
    final notifier = ref.read(umDiagnosticControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('فاحص صحة User Manager (7 نقاط)'),
        actions: [
          IconButton(
            icon: state.isRunning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'إعادة الفحص الشامل',
            onPressed:
                state.isRunning ? null : () => notifier.runAllDiagnostics(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header summary card
          Card(
            color: AppColors.navyPrimary,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.health_and_safety,
                          color: AppColors.cyanAccent, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        state.isRunning
                            ? 'جاري تشخيص سلامة User Manager...'
                            : (state.overallSummary ?? 'فحص صحة User Manager'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يقوم هذا الفاحص باختبار 7 ركائز أساسية لضمان عمل كروت اليوزر منجر والجلسات الحية بدون أخطاء أو تعليق.',
                    style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Diagnostic check items
          ...state.checks.map((item) => _buildCheckCard(context, item)),
        ],
      ),
    );
  }

  Widget _buildCheckCard(BuildContext context, DiagnosticItem item) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (item.status) {
      case DiagnosticStatus.pass:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_rounded;
        statusText = 'سليم ومفعل';
        break;
      case DiagnosticStatus.warn:
        statusColor = AppColors.warning;
        statusIcon = Icons.warning_amber_rounded;
        statusText = 'تنبيه / غير مكتمل';
        break;
      case DiagnosticStatus.fail:
        statusColor = AppColors.danger;
        statusIcon = Icons.cancel_rounded;
        statusText = 'فشل / معطل';
        break;
      case DiagnosticStatus.checking:
        statusColor = AppColors.cyanAccent;
        statusIcon = Icons.hourglass_top_rounded;
        statusText = 'جاري الفحص...';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const Divider(height: 18),
            Text(
              item.details,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            if (item.suggestedCommand != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.suggestedCommand!,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: AppColors.cyanAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy,
                          size: 18, color: Colors.white70),
                      tooltip: 'نسخ الأمر المقترح',
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: item.suggestedCommand!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم نسخ الأمر إلى الحافظة'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
