import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/app_exit_service.dart';
import '../../routers/domain/routers_notifier.dart';
import '../domain/dashboard_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashState = ref.watch(dashboardControllerProvider);
    final routerState = ref.watch(routersControllerProvider);
    final activeRouter = routerState.activeRouter;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          AppExitService.handleDoubleTapBack(context, ref);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MikroManager Pro',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'تحديث المؤشرات',
              onPressed: () => ref
                  .read(dashboardControllerProvider.notifier)
                  .refreshMetrics(),
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new_rounded,
                  color: AppColors.danger),
              tooltip: 'خروج آمن من التطبيق',
              onPressed: () => AppExitService.confirmAndExit(context, ref),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              ref.read(dashboardControllerProvider.notifier).refreshMetrics(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Compact Status Header
                _buildCompactStatusHeader(context, ref, dashState, activeRouter),
                const SizedBox(height: 12),

                // 2. Compact Resource Metrics (CPU, RAM, Uptime, Active Users)
                _buildCompactMetricsRow(context, dashState),
                const SizedBox(height: 14),

                // 3. Compact Live Traffic Card
                _buildLiveTrafficCard(dashState, ref),
                const SizedBox(height: 20),

                // 4. Section 1: Cards & Sales
                _buildSectionHeader(
                  title: 'الكروت والمبيعات',
                  subtitle: 'توليد، طباعة، فحص وإدارة مبيعات الكروت',
                  icon: Icons.confirmation_number_rounded,
                  color: AppColors.cyanAccent,
                ),
                const SizedBox(height: 10),
                _buildTaskGrid(
                  context,
                  ref,
                  isTablet: isTablet,
                  tasks: [
                    _DashboardTask(
                      title: 'توليد الكروت',
                      icon: Icons.add_card_rounded,
                      color: const Color(0xFF06B6D4), // Cyan
                      onTap: () => context.push('/vouchers/generate'),
                    ),
                    _DashboardTask(
                      title: 'إدارة الكروت',
                      icon: Icons.style_rounded,
                      color: const Color(0xFF6366F1), // Indigo
                      onTap: () => context.go('/vouchers'),
                    ),
                    _DashboardTask(
                      title: 'فحص كرت',
                      icon: Icons.qr_code_scanner_rounded,
                      color: const Color(0xFF10B981), // Emerald
                      onTap: () => context.push('/card-inquiry'),
                    ),
                    _DashboardTask(
                      title: 'قوالب الطباعة',
                      icon: Icons.palette_rounded,
                      color: const Color(0xFFF59E0B), // Amber
                      onTap: () => context.push('/templates'),
                    ),
                    _DashboardTask(
                      title: 'أرشيف الكروت',
                      icon: Icons.folder_zip_rounded,
                      color: const Color(0xFFF97316), // Orange
                      onTap: () => context.push('/pdf-archive'),
                    ),
                    _DashboardTask(
                      title: 'المبيعات والموزعون',
                      icon: Icons.point_of_sale_rounded,
                      color: const Color(0xFF14B8A6), // Teal
                      onTap: () => context.go('/reports'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 5. Section 2: Network & Monitoring
                _buildSectionHeader(
                  title: 'الشبكة والمراقبة',
                  subtitle: 'مراقبة الجلسات والسيرفرات وحركة البيانات',
                  icon: Icons.hub_rounded,
                  color: AppColors.navyPrimary,
                ),
                const SizedBox(height: 10),
                _buildTaskGrid(
                  context,
                  ref,
                  isTablet: isTablet,
                  tasks: [
                    _DashboardTask(
                      title: 'التقارير والإحصائيات',
                      icon: Icons.analytics_rounded,
                      color: const Color(0xFF3B82F6), // Blue
                      onTap: () => context.go('/reports'),
                    ),
                    _DashboardTask(
                      title: 'حركة المنافذ',
                      icon: Icons.swap_vert_circle_rounded,
                      color: const Color(0xFF8B5CF6), // Purple
                      onTap: () => context.push('/interfaces'),
                    ),
                    _DashboardTask(
                      title: 'المشتركون النشطون',
                      icon: Icons.people_alt_rounded,
                      color: const Color(0xFF0284C7), // Sky Blue
                      onTap: () => context.go('/subscribers'),
                    ),
                    _DashboardTask(
                      title: 'سيرفر الهوتسبوت',
                      icon: Icons.wifi_tethering_rounded,
                      color: const Color(0xFF0EA5E9), // Light Blue
                      onTap: () => context.push('/hotspot'),
                    ),
                    _DashboardTask(
                      title: 'خادم User Manager',
                      icon: Icons.manage_accounts_rounded,
                      color: const Color(0xFF9333EA), // Deep Purple
                      onTap: () => context.push('/userman'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 6. Section 3: Management & System
                _buildSectionHeader(
                  title: 'الإدارة والنظام',
                  subtitle: 'إدارة أجهزة الراوتر والتنبيهات وإعدادات الأمان',
                  icon: Icons.tune_rounded,
                  color: AppColors.warning,
                ),
                const SizedBox(height: 10),
                _buildTaskGrid(
                  context,
                  ref,
                  isTablet: isTablet,
                  tasks: [
                    _DashboardTask(
                      title: 'أجهزة الراوتر',
                      icon: Icons.router_rounded,
                      color: const Color(0xFF475569), // Slate
                      onTap: () => context.push('/routers'),
                    ),
                    _DashboardTask(
                      title: 'فحص صحة UM',
                      icon: Icons.health_and_safety_rounded,
                      color: const Color(0xFF16A34A), // Green
                      onTap: () => context.push('/um-diagnostic'),
                    ),
                    _DashboardTask(
                      title: 'تنبيهات تليجرام',
                      icon: Icons.send_rounded,
                      color: const Color(0xFF0284C7), // Blue
                      onTap: () => context.push('/telegram'),
                    ),
                    _DashboardTask(
                      title: 'النسخ الاحتياطي',
                      icon: Icons.backup_rounded,
                      color: const Color(0xFFD97706), // Amber
                      onTap: () => context.go('/settings'),
                    ),
                    _DashboardTask(
                      title: 'الإعدادات العامة',
                      icon: Icons.settings_suggest_rounded,
                      color: const Color(0xFF64748B), // Slate Grey
                      onTap: () => context.go('/settings'),
                    ),
                    _DashboardTask(
                      title: 'خروج من التطبيق',
                      icon: Icons.power_settings_new_rounded,
                      color: AppColors.danger,
                      onTap: () => AppExitService.confirmAndExit(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // Compact Status Header
  // =========================================================================

  Widget _buildCompactStatusHeader(
    BuildContext context,
    WidgetRef ref,
    DashboardState dashState,
    dynamic activeRouter,
  ) {
    final isConnected = dashState.isConnected;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.danger.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected ? AppColors.success : AppColors.danger,
              boxShadow: [
                BoxShadow(
                  color: (isConnected ? AppColors.success : AppColors.danger)
                      .withValues(alpha: 0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  activeRouter?.name ?? 'راوتر MikroTik',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  isConnected
                      ? '${dashState.boardName.isEmpty ? "MikroTik" : dashState.boardName} • v${dashState.version}'
                      : 'غير متصل بالراوتر - انقر لإعادة الاتصال',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => context.push('/routers'),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cyanAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swap_horiz_rounded,
                      size: 16, color: AppColors.cyanAccent),
                  SizedBox(width: 4),
                  Text(
                    'الراوترات',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.cyanAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Compact Resource Metrics Row
  // =========================================================================

  Widget _buildCompactMetricsRow(BuildContext context, DashboardState dashState) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            title: 'المعالج',
            value: dashState.cpuLoad.isEmpty ? '0%' : dashState.cpuLoad,
            icon: Icons.memory_rounded,
            color: const Color(0xFF06B6D4),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricTile(
            title: 'الذاكرة',
            value: dashState.freeMemory.isEmpty ? 'N/A' : dashState.freeMemory,
            icon: Icons.storage_rounded,
            color: const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricTile(
            title: 'المتصلون',
            value: '${dashState.activeUsersCount}',
            icon: Icons.people_rounded,
            color: const Color(0xFF10B981),
            onTap: () => context.go('/subscribers'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricTile(
            title: 'التشغيل',
            value: dashState.uptime.isEmpty ? '0s' : dashState.uptime,
            icon: Icons.timer_outlined,
            color: const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // Live Traffic Card
  // =========================================================================

  Widget _buildLiveTrafficCard(DashboardState dashState, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.show_chart_rounded,
                        color: AppColors.cyanAccent, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'الترافيك اللحظي',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (dashState.availableInterfaces.isNotEmpty)
                  DropdownButton<String>(
                    value: dashState.selectedInterface,
                    underline: const SizedBox(),
                    isDense: true,
                    items: dashState.availableInterfaces.map((iface) {
                      return DropdownMenuItem(
                        value: iface,
                        child: Text(
                          iface,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(dashboardControllerProvider.notifier)
                            .selectInterface(val);
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: AppColors.cyanAccent,
                            borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 4),
                    Text(
                      'تنزيل: ${dashState.currentRxMbps.toStringAsFixed(2)} Mbps',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 4),
                    Text(
                      'رفع: ${dashState.currentTxMbps.toStringAsFixed(2)} Mbps',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: dashState.trafficHistory.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'جاري قراءة ترافيك الواجهة...',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: const FlGridData(
                            show: true, drawVerticalLine: false),
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: AppColors.border),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: dashState.trafficHistory
                                .map((p) => FlSpot(p.time, p.rxMbps))
                                .toList(),
                            isCurved: true,
                            color: AppColors.cyanAccent,
                            barWidth: 2.5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color:
                                  AppColors.cyanAccent.withValues(alpha: 0.12),
                            ),
                          ),
                          LineChartBarData(
                            spots: dashState.trafficHistory
                                .map((p) => FlSpot(p.time, p.txMbps))
                                .toList(),
                            isCurved: true,
                            color: AppColors.warning,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.warning.withValues(alpha: 0.08),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // Section Header
  // =========================================================================

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // Unified Task Grid
  // =========================================================================

  Widget _buildTaskGrid(
    BuildContext context,
    WidgetRef ref, {
    required bool isTablet,
    required List<_DashboardTask> tasks,
  }) {
    final crossAxisCount = isTablet ? 4 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isTablet ? 1.3 : 1.05,
      ),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(_DashboardTask task) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: task.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: task.color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: task.color.withValues(alpha: 0.22),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: task.color.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    task.icon,
                    size: 24,
                    color: task.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: task.color,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardTask {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardTask({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
