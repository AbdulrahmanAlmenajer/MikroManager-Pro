import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../routers/domain/routers_notifier.dart';
import '../domain/dashboard_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashState = ref.watch(dashboardControllerProvider);
    final routerState = ref.watch(routersControllerProvider);
    final activeRouter = routerState.activeRouter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم (Dashboard)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث المؤشرات',
            onPressed: () =>
                ref.read(dashboardControllerProvider.notifier).refreshMetrics(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'الإعدادات العامة',
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج من الراوتر',
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(dashboardControllerProvider.notifier).refreshMetrics(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Router Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: dashState.isConnected
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.danger.withValues(alpha: 0.15),
                        child: Icon(
                          dashState.isConnected
                              ? Icons.cloud_done
                              : Icons.cloud_off,
                          color: dashState.isConnected
                              ? AppColors.success
                              : AppColors.danger,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeRouter?.name ?? 'لم يتم تحديد راوتر',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              dashState.isConnected
                                  ? '${dashState.boardName} | RouterOS ${dashState.version}'
                                  : 'غير متصل بالراوتر - انقر للاتصال',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: const BorderSide(color: AppColors.danger),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () => _confirmLogout(context, ref),
                        icon: const Icon(Icons.power_settings_new, size: 16),
                        label:
                            const Text('خروج', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // System Resources Row (CPU, RAM, Uptime)
              Row(
                children: [
                  Expanded(
                    child: _buildResourceCard(
                      'المعالج CPU',
                      dashState.cpuLoad,
                      Icons.memory,
                      AppColors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildResourceCard(
                      'الذاكرة RAM',
                      dashState.freeMemory,
                      Icons.storage,
                      AppColors.warning,
                      subtext: 'المتاح من ${dashState.totalMemory}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildResourceCard(
                      'مدة التشغيل',
                      dashState.uptime,
                      Icons.timer_outlined,
                      AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Active Users Quick Card
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.navyPrimary,
                    child: Icon(Icons.people, color: Colors.white),
                  ),
                  title: const Text('المتصلون حالياً بالشبكة',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('إجمالي جلسات الهوتس بوت النشطة'),
                  trailing: Text(
                    '${dashState.activeUsersCount} مشترك',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.cyanAccent),
                  ),
                  onTap: () => context.go('/hotspot'),
                ),
              ),
              const SizedBox(height: 16),

              // Live Traffic Graph Card (fl_chart)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.show_chart,
                                  color: AppColors.cyanAccent),
                              SizedBox(width: 8),
                              Text('الترافيك اللحظي للشبكة',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                          if (dashState.availableInterfaces.isNotEmpty)
                            DropdownButton<String>(
                              value: dashState.selectedInterface,
                              underline: const SizedBox(),
                              items: dashState.availableInterfaces.map((iface) {
                                return DropdownMenuItem(
                                    value: iface,
                                    child: Text(iface,
                                        style: const TextStyle(fontSize: 12)));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  ref
                                      .read(
                                          dashboardControllerProvider.notifier)
                                      .selectInterface(val);
                                }
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Legend & Live Speeds
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                  width: 12,
                                  height: 12,
                                  color: AppColors.cyanAccent),
                              const SizedBox(width: 6),
                              Text(
                                  'تنزيل (Rx): ${dashState.currentRxMbps.toStringAsFixed(2)} Mbps',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 12,
                                  height: 12,
                                  color: AppColors.warning),
                              const SizedBox(width: 6),
                              Text(
                                  'رفع (Tx): ${dashState.currentTxMbps.toStringAsFixed(2)} Mbps',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // The fl_chart LineChart
                      SizedBox(
                        height: 160,
                        child: dashState.trafficHistory.isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text('جاري قراءة ترافيك الواجهة...',
                                      style: TextStyle(
                                          color: AppColors.textSecondary)),
                                ),
                              )
                            : LineChart(
                                LineChartData(
                                  gridData: const FlGridData(
                                      show: true, drawVerticalLine: false),
                                  titlesData: const FlTitlesData(
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  lineBarsData: [
                                    // Rx (Download) Line
                                    LineChartBarData(
                                      spots: dashState.trafficHistory
                                          .map((p) => FlSpot(p.time, p.rxMbps))
                                          .toList(),
                                      isCurved: true,
                                      color: AppColors.cyanAccent,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: AppColors.cyanAccent
                                            .withValues(alpha: 0.15),
                                      ),
                                    ),
                                    // Tx (Upload) Line
                                    LineChartBarData(
                                      spots: dashState.trafficHistory
                                          .map((p) => FlSpot(p.time, p.txMbps))
                                          .toList(),
                                      isCurved: true,
                                      color: AppColors.warning,
                                      barWidth: 2.5,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: AppColors.warning
                                            .withValues(alpha: 0.1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Shortcuts Grid
              const Text('إجراءات سريعة',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      icon: Icons.confirmation_number_outlined,
                      label: 'توليد كروت',
                      color: AppColors.cyanAccent,
                      onTap: () => context.go('/vouchers'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      icon: Icons.wifi,
                      label: 'المتصلون',
                      color: AppColors.success,
                      onTap: () => context.go('/hotspot'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      icon: Icons.bar_chart,
                      label: 'التقارير',
                      color: AppColors.navyPrimary,
                      onTap: () => context.go('/reports'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      icon: Icons.hub_outlined,
                      label: 'الواجهات',
                      color: AppColors.warning,
                      onTap: () => context.push('/interfaces'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(
      String title, String value, IconData icon, Color color,
      {String? subtext}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            const SizedBox(height: 2),
            Text(title,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
            if (subtext != null) ...[
              const SizedBox(height: 2),
              Text(subtext,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textSecondary)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text(
            'هل أنت متأكد من قطع الاتصال بالراوتر وتسجيل الخروج؟ ستتم إعادتك لشاشة تسجيل الدخول.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(routersControllerProvider.notifier).logout();
            },
            child: const Text('قطع الاتصال',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
