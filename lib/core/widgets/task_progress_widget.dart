import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TaskProgressState {
  final int currentStage;
  final int totalStages;
  final String stageTitle;
  final String? detailText;
  final double? progressPercent; // 0.0 to 1.0, null = indeterminate
  final bool isCancelling;

  const TaskProgressState({
    this.currentStage = 1,
    this.totalStages = 3,
    required this.stageTitle,
    this.detailText,
    this.progressPercent,
    this.isCancelling = false,
  });

  TaskProgressState copyWith({
    int? currentStage,
    int? totalStages,
    String? stageTitle,
    String? detailText,
    double? progressPercent,
    bool? isCancelling,
  }) {
    return TaskProgressState(
      currentStage: currentStage ?? this.currentStage,
      totalStages: totalStages ?? this.totalStages,
      stageTitle: stageTitle ?? this.stageTitle,
      detailText: detailText ?? this.detailText,
      progressPercent: progressPercent ?? this.progressPercent,
      isCancelling: isCancelling ?? this.isCancelling,
    );
  }
}

/// Unified cancellable progress banner for heavy operations
class AppTaskProgressBanner extends StatelessWidget {
  final TaskProgressState progress;
  final VoidCallback? onCancel;

  const AppTaskProgressBanner({
    super.key,
    required this.progress,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final percentVal = progress.progressPercent;
    final percentText =
        percentVal != null ? '${(percentVal * 100).toInt()}%' : null;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.cyanAccent.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.cyanAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'المرحلة ${progress.currentStage} من ${progress.totalStages}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navyPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    progress.stageTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (percentText != null)
                  Text(
                    percentText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.cyanAccent,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentVal,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.cyanAccent),
              ),
            ),
            if (progress.detailText != null || onCancel != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      progress.detailText ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onCancel != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: progress.isCancelling ? null : onCancel,
                      icon: progress.isCancelling
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.danger,
                              ),
                            )
                          : const Icon(Icons.cancel_outlined, size: 16),
                      label: Text(
                        progress.isCancelling
                            ? 'جاري الإلغاء...'
                            : 'إلغاء المهمة',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
