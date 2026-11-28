import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../database/database_provider.dart';
import '../session/session_controller.dart';
import '../tasks/task_runner.dart';

class AppExitService {
  static DateTime? _lastBackPressTime;

  /// Handles double-tap back to exit from the primary Dashboard
  static Future<bool> handleDoubleTapBack(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اضغط مرة أخرى للخروج من التطبيق'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    await confirmAndExit(context, ref);
    return false;
  }

  /// Displays confirmation dialog and safely exits if confirmed
  static Future<void> confirmAndExit(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final taskRunner = ref.read(taskRunnerProvider);
    final hasActiveTasks = await taskRunner.hasRunningTasks();

    if (!context.mounted) return;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.power_settings_new_rounded,
          color: AppColors.danger,
          size: 40,
        ),
        title: const Text(
          'الخروج من التطبيق',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasActiveTasks) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.warning),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تنبيه: توجد عمليات رفع كروت أو مهام قيد التنفيذ! الخروج الآن قد يقطع العملية.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            const Text(
              'هل تريد إغلاق تطبيق MikroManager Pro وقطع الاتصال بالراوتر بأمان؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('خروج وإغلاق'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      await performCleanExit(ref);
    }
  }

  /// Cleans up all sessions, sockets, and databases, then exits the application
  static Future<void> performCleanExit(WidgetRef ref) async {
    try {
      // 1. Cancel running tasks
      final taskRunner = ref.read(taskRunnerProvider);
      await taskRunner.cancelAllRunningTasks();
    } catch (_) {}

    try {
      // 2. Disconnect MikroTik socket session cleanly
      await ref.read(sessionControllerProvider.notifier).logout();
    } catch (_) {}

    try {
      // 3. Close Drift database connection
      final db = ref.read(databaseProvider);
      await db.close();
    } catch (_) {}

    // 4. Terminate process cleanly
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemNavigator.pop();
    } else {
      exit(0);
    }
  }
}
