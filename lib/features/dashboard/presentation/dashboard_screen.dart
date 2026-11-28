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
    final kpiAsync = ref.watch(dashboardKpiProvider);
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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'MikroManager Pro',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'تحديث المؤشرات',
              onPressed: () {
                ref
                    .read(dashboardControllerProvider.notifier)
                    .refreshMetrics();
                ref.invalidate(dashboardKpiProvider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new_rounded,
                  color: Colors.white),
              tooltip: 'خروج آمن من التطبيق',
              onPressed: () => AppExitService.confirmAndExit(context, ref),
            ),
          ],
        ),
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await ref
                .read(dashboardControllerProvider.notifier)
                .refreshMetrics();
            ref.invalidate(dashboardKpiProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Compact Emerald Status Card
                _buildCompactEmeraldStatusCard(
                    context, ref, dashState, activeRouter),
                const SizedBox(height: 14),

                // 2. KPI Summary Cards 2x2
                _buildKpiSummaryGrid(kpiAsync),
                const SizedBox(height: 20),

                // 3. Section Title: الخدمات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.grid_view_rounded,
                            size: 20, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'الخدمات والعمليات',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'نقطة وصول موحدة',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. Unified 3-Column Services Grid
                _buildServicesGrid(context, ref, isTablet: isTablet),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 1. Compact Emerald Status Card
  // =========================================================================

  Widget _buildCompactEmeraldStatusCard(
    BuildContext context,
    WidgetRef ref,
    DashboardState dashState,
    dynamic activeRouter,
  ) {
    final isConnected = dashState.isConnected;
    final isCloud = (activeRouter?.host ?? '').toString().contains('.sn.mynetname.net');

    // Parse memory percentage for progress bar
    double memPercent = 0.5;
    try {
      final free = double.tryParse(dashState.freeMemory.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      final total = double.tryParse(dashState.totalMemory.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 1;
      if (total > 0) {
        memPercent = ((total - free) / total).clamp(0.0, 1.0);
      }
    } catch (_) {}

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF0D7A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Badge, IP & Connected count, Connection status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCloud ? Icons.cloud_outlined : Icons.wifi_outlined,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCloud ? 'سحابي (Cloud)' : 'محلي (LAN)',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${dashState.activeUsersCount} متصل • ${activeRouter?.host ?? "192.168.88.1"}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnected ? const Color(0xFF34D399) : const Color(0xFFF87171),
                  boxShadow: [
                    BoxShadow(
                      color: (isConnected
                              ? const Color(0xFF34D399)
                              : const Color(0xFFF87171))
                          .withValues(alpha: 0.7),
                      blurRadius: 6,
                      spreadRadius: 1.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.white24),
          const SizedBox(height: 10),

          // 3 Organized Rows
          // Row 1: RouterOS version & Uptime
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEmeraldInfoTile(
                title: 'إصدار الراوتر',
                value: dashState.version.isNotEmpty ? 'RouterOS ${dashState.version}' : 'RouterOS',
                icon: Icons.developer_board_rounded,
              ),
              _buildEmeraldInfoTile(
                title: 'مدة التشغيل',
                value: dashState.uptime.isNotEmpty ? dashState.uptime : '-',
                icon: Icons.access_time_rounded,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Temperature & CPU Load
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEmeraldInfoTile(
                title: 'الحرارة',
                value: 'طبيعية (38°C)',
                icon: Icons.thermostat_rounded,
              ),
              _buildEmeraldInfoTile(
                title: 'المعالج (CPU)',
                value: dashState.cpuLoad.isNotEmpty ? dashState.cpuLoad : '0%',
                icon: Icons.memory_rounded,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 3: Active users & RAM
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEmeraldInfoTile(
                title: 'المستخدمون النشطون',
                value: '${dashState.activeUsersCount} مشترك',
                icon: Icons.people_alt_rounded,
              ),
              _buildEmeraldInfoTile(
                title: 'الذاكرة (RAM)',
                value: '${dashState.freeMemory} متاح',
                icon: Icons.storage_rounded,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Thin RAM Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: memPercent,
              minHeight: 4,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildEmeraldInfoTile({
    required String title,
    required String value,
    required IconData icon,
    bool alignEnd = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!alignEnd) ...[
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 4),
        ],
        Column(
          crossAxisAlignment:
              alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        if (alignEnd) ...[
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: Colors.white70),
        ],
      ],
    );
  }

  // =========================================================================
  // 2. KPI Summary Cards 2x2
  // =========================================================================

  Widget _buildKpiSummaryGrid(AsyncValue<DashboardKpiData> kpiAsync) {
    final kpi = kpiAsync.value ?? const DashboardKpiData();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        _buildKpiCard(
          title: 'إجمالي البيع',
          value: '${kpi.totalSalesAmount.toStringAsFixed(0)} YER',
          icon: Icons.account_balance_wallet_rounded,
          color: AppColors.addGreen,
        ),
        _buildKpiCard(
          title: 'الكروت المولدة (30 يوم)',
          value: '${kpi.generatedLast30Days}',
          icon: Icons.layers_rounded,
          color: const Color(0xFF0284C7),
        ),
        _buildKpiCard(
          title: 'الكروت المباعة',
          value: '${kpi.soldCardsCount}',
          icon: Icons.check_circle_outline_rounded,
          color: const Color(0xFF6366F1),
        ),
        _buildKpiCard(
          title: 'الكروت المتبقية',
          value: '${kpi.remainingCardsCount}',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFFD97706),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 3. Unified 3-Column Services Grid
  // =========================================================================

  Widget _buildServicesGrid(
    BuildContext context,
    WidgetRef ref, {
    required bool isTablet,
  }) {
    final tasks = [
      _ServiceItem(
        title: 'نظام اليوزرمنجر',
        icon: Icons.manage_accounts_rounded,
        color: const Color(0xFF8B5CF6),
        onTap: () => context.push('/userman'),
      ),
      _ServiceItem(
        title: 'نظام الهوتسبوت',
        icon: Icons.wifi_tethering_rounded,
        color: const Color(0xFF0284C7),
        onTap: () => context.push('/hotspot'),
      ),
      _ServiceItem(
        title: 'تصاميم وتوليد الكروت',
        icon: Icons.add_card_rounded,
        color: AppColors.addGreen,
        onTap: () => context.push('/vouchers/generate'),
      ),
      _ServiceItem(
        title: 'المتصلين الآن',
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF0369A1),
        onTap: () => context.push('/subscribers'),
      ),
      _ServiceItem(
        title: 'الحسابات والتقارير',
        icon: Icons.analytics_rounded,
        color: const Color(0xFF3B82F6),
        onTap: () => context.push('/reports'),
      ),
      _ServiceItem(
        title: 'موزعين الكروت',
        icon: Icons.point_of_sale_rounded,
        color: const Color(0xFF14B8A6),
        onTap: () => context.push('/reports'),
      ),
      _ServiceItem(
        title: 'إدارة المايكروتك',
        icon: Icons.hub_rounded,
        color: const Color(0xFFD97706),
        onTap: () => _showMikrotikManagementSheet(context),
      ),
      _ServiceItem(
        title: 'فحص واستعلام كرت',
        icon: Icons.qr_code_scanner_rounded,
        color: const Color(0xFF10B981),
        onTap: () => context.push('/card-inquiry'),
      ),
      _ServiceItem(
        title: 'الراوترات والملف',
        icon: Icons.router_rounded,
        color: const Color(0xFF475569),
        onTap: () => context.push('/routers'),
      ),
    ];

    final crossAxisCount = isTablet ? 4 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isTablet ? 1.25 : 1.05,
      ),
      itemBuilder: (context, index) {
        final item = tasks[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                        color: item.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, size: 24, color: item.color),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // Mikrotik Management Sub-Sheet
  // =========================================================================

  void _showMikrotikManagementSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'أدوات إدارة المايكروتك المتقدمة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.swap_vert_circle_rounded,
                        color: Color(0xFF6366F1)),
                  ),
                  title: const Text('حركة المنافذ والترافيك اللحظي'),
                  subtitle: const Text('مراقبة استهلاك المنافذ وسرعات التحميل'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/interfaces');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFECFDF5),
                    child: Icon(Icons.health_and_safety_rounded,
                        color: Color(0xFF10B981)),
                  ),
                  title: const Text('فاحص صحة User Manager'),
                  subtitle: const Text('فحص منافذ RADIUS وصلاحيات المالك'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/um-diagnostic');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFF0FDF4),
                    child: Icon(Icons.send_rounded, color: Color(0xFF0284C7)),
                  ),
                  title: const Text('إشعارات وتنبيهات بوت تليجرام'),
                  subtitle: const Text('إرسال تقارير المبيعات وانقطاعات الراوتر'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/telegram');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFEF3C7),
                    child: Icon(Icons.backup_rounded, color: Color(0xFFD97706)),
                  ),
                  title: const Text('النسخ الاحتياطي والأمان'),
                  subtitle: const Text('أخذ نسخ احتياطية لقواعد البيانات والإعدادات'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/settings');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServiceItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ServiceItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
