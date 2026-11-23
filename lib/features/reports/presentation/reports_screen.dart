// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/session/session_controller.dart';
import '../data/reports_repository.dart';
import '../domain/reports_notifier.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _directSalesFilter =
      'all'; // 'all', 'hotspot', 'usermanager', 'printed', 'unprinted'
  String _directSalesSearch = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final honestReportAsync = ref.watch(honestReportProvider);
    final paymentsAsync = ref.watch(paymentsListProvider);
    final auditLogsAsync = ref.watch(auditLogsProvider);
    final cardSalesAsync = ref.watch(cardSalesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والمبيعات والجرد'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.cyanAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.analytics_outlined), text: 'الأرقام الصادقة'),
            Tab(
                icon: Icon(Icons.compare_arrows_outlined),
                text: 'مقارنة الأنظمة'),
            Tab(
                icon: Icon(Icons.point_of_sale_outlined),
                text: 'المبيعات المباشرة'),
            Tab(icon: Icon(Icons.payments_outlined), text: 'التحصيلات الفعلية'),
            Tab(icon: Icon(Icons.price_change_outlined), text: 'تسعير الفئات'),
            Tab(icon: Icon(Icons.history_edu_outlined), text: 'سجل العمليات'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'تصدير تقرير PDF',
            onPressed: () {
              honestReportAsync
                  .whenData((data) => _exportPdfHonestReport(context, data));
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart_outlined),
            tooltip: 'تصدير ملف CSV',
            onPressed: () {
              honestReportAsync
                  .whenData((data) => _exportCsvHonestReport(context, data));
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث البيانات',
            onPressed: () {
              ref.invalidate(honestReportProvider);
              ref.invalidate(paymentsListProvider);
              ref.invalidate(cardSalesListProvider);
              ref.invalidate(auditLogsProvider);
              ref.invalidate(profilePricesListProvider);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHonestNumbersTab(honestReportAsync),
          _buildComparisonTab(honestReportAsync),
          _buildDirectSalesTab(cardSalesAsync),
          _buildPaymentsTab(paymentsAsync),
          _buildProfilePricesTab(honestReportAsync),
          _buildAuditLogsTab(auditLogsAsync),
        ],
      ),
    );
  }

  // =========================================================================
  // Tab 1: Honest Numbers (Stock vs Estimated Sales vs Collections)
  // =========================================================================

  Widget _buildHonestNumbersTab(AsyncValue<HonestReportData> reportAsync) {
    return reportAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري حساب المخزون ومطابقة المبيعات التقديرية...'),
          ],
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.danger),
              const SizedBox(height: 12),
              Text('خطأ في تحميل التقرير: $e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(honestReportProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
      data: (report) {
        final stock = report.stock;
        final sales = report.sales;
        final payments = report.payments;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice banner if unpriced profiles exist
              if (stock.unpricedProfiles.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.warning),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'يوجد فئات (بروفايلات) غير مسعرة: ${stock.unpricedProfiles.join(", ")}. يرجى تحديد أسعارها لتكون القيمة المالية دقيقة.',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _tabController.animateTo(2),
                        child: const Text('تسعير الآن'),
                      ),
                    ],
                  ),
                ),

              // SECTION 1: Stock Summary (جرد المخزون الفعلي بالراوتر)
              const Row(
                children: [
                  Icon(Icons.inventory_2_outlined,
                      color: AppColors.cyanAccent, size: 20),
                  SizedBox(width: 8),
                  Text('جرد المخزون الحالي في الراوتر',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'المخزون الجاهز (غير مستخدم)',
                      '${stock.unusedCards} كرت',
                      '${stock.unusedValue.toStringAsFixed(0)} ر.ي',
                      Icons.card_giftcard,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'قيد الاستخدام (نشطة)',
                      '${stock.activeCards} كرت',
                      '${stock.activeValue.toStringAsFixed(0)} ر.ي',
                      Icons.signal_cellular_alt,
                      AppColors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'منتهية الصلاحية',
                      '${stock.expiredCards} كرت',
                      'مستهلكة',
                      Icons.history_toggle_off,
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Hotspot vs User Manager Stock Breakdown
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.cyanAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Hotspot: ${stock.hotspotCardsCount} كرت (${stock.hotspotValue.toStringAsFixed(0)} ر.ي)',
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 16, width: 1, color: Colors.grey.shade300),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.navyPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'User Manager: ${stock.userManCardsCount} كرت (${stock.userManValue.toStringAsFixed(0)} ر.ي)',
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // SECTION 2: Estimated Sales (المبيعات التقديرية بناءً على أول ظهور)
              Card(
                elevation: 2,
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
                              Icon(Icons.trending_up,
                                  color: AppColors.cyanAccent, size: 20),
                              SizedBox(width: 8),
                              Text('المبيعات التقديرية (بناءً على أول ظهور)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.cyanAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('أرقام صادقة ومطابقة',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.cyanAccent)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ميكروتيك لا يسجل تاريخ بيع الكرت للمشترك، بل يسجل لحظة بدء الاستهلاك، لذا يتم رصد أول ظهور للكارت لاحتساب المبيعات بدقة.',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSalesMetricTile(
                              'مبيعات اليوم',
                              '${sales.today.cardsCount} كرت',
                              '${sales.today.totalEstimatedAmount.toStringAsFixed(0)} ر.ي',
                              sales.today.hasApproximateDates,
                            ),
                          ),
                          Expanded(
                            child: _buildSalesMetricTile(
                              'آخر 7 أيام',
                              '${sales.last7Days.cardsCount} كرت',
                              '${sales.last7Days.totalEstimatedAmount.toStringAsFixed(0)} ر.ي',
                              sales.last7Days.hasApproximateDates,
                            ),
                          ),
                          Expanded(
                            child: _buildSalesMetricTile(
                              'آخر 30 يوماً',
                              '${sales.last30Days.cardsCount} كرت',
                              '${sales.last30Days.totalEstimatedAmount.toStringAsFixed(0)} ر.ي',
                              sales.last30Days.hasApproximateDates,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.cyanAccent.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'مبيعات Hotspot: ${sales.hotspotRevenue.toStringAsFixed(0)} ر.ي (${sales.hotspotCardsCount} كرت)',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.cyanAccent),
                            ),
                            Text(
                              'مبيعات User Manager: ${sales.userManRevenue.toStringAsFixed(0)} ر.ي (${sales.userManCardsCount} كرت)',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navyPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // SECTION 3: Reconciliation (المطابقة مع التحصيل الفعلي والعجز)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.account_balance,
                              color: AppColors.success, size: 20),
                          SizedBox(width: 8),
                          Text('المطابقة المالية والتحصيل',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('إجمالي التحصيل الفعلي المستلم',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                                Text(
                                  '${payments.totalPayments.toStringAsFixed(0)} ر.ي',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.success),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('فارق التحصيل (عجز / فائض)',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                                Text(
                                  '${payments.balance >= 0 ? "+" : ""}${payments.balance.toStringAsFixed(0)} ر.ي',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: payments.balance >= 0
                                        ? AppColors.success
                                        : AppColors.danger,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _showAddPaymentDialog(context),
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('إضافة دفعة'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // SECTION 4: Recent Observations List
              const Text('آخر الكروت المسجلة قيد الاستخدام',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              if (sales.recentObservations.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('لا توجد ملاحظات استخدام مسجلة حتى الآن.',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sales.recentObservations.take(10).length,
                  itemBuilder: (context, idx) {
                    final obs = sales.recentObservations[idx];
                    final price = report.profilePrices[obs.profile] ?? 0.0;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.cyanAccent.withValues(alpha: 0.15),
                          child: const Icon(Icons.wifi,
                              color: AppColors.cyanAccent, size: 18),
                        ),
                        title: Text(obs.cardName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(
                          'الفئة: ${obs.profile}  |  ${DateFormat('yyyy/MM/dd HH:mm').format(obs.firstSeenAt)}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (obs.dateIsApproximate)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text('تاريخ تقريبي',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.warning)),
                              ),
                            Text('${price.toStringAsFixed(0)} ر.ي',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.cyanAccent)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // Tab 2: Comparison (Hotspot vs User Manager)
  // =========================================================================

  Widget _buildComparisonTab(AsyncValue<HonestReportData> reportAsync) {
    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ في مقارنة الأنظمة: $e')),
      data: (report) {
        final c = report.comparison;
        final totalRev = c.hotspotRevenue + c.userManRevenue;
        final hsShare =
            totalRev > 0 ? (c.hotspotRevenue / totalRev) * 100 : 0.0;
        final umShare =
            totalRev > 0 ? (c.userManRevenue / totalRev) * 100 : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading System Banner
              Card(
                color: c.leadingSystem == 'User Manager'
                    ? AppColors.navyPrimary
                    : (c.leadingSystem == 'Hotspot'
                        ? AppColors.cyanAccent
                        : const Color(0xFF334155)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          color: Colors.amber, size: 36),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'النظام الأكثر مساهمة في الإيرادات',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              c.leadingSystem,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'إجمالي الإيراد: ${totalRev.toStringAsFixed(0)} ر.ي',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Side-by-Side Comparison Cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotspot Card
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: AppColors.cyanAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Hotspot',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            _buildComparisonMetric(
                                'الكروت الكلية', '${c.hotspotTotalCards} كرت'),
                            _buildComparisonMetric(
                                'الكروت النشطة', '${c.hotspotActiveCards} كرت'),
                            _buildComparisonMetric('الإيراد التقديري',
                                '${c.hotspotRevenue.toStringAsFixed(0)} ر.ي'),
                            _buildComparisonMetric('متوسط سعر الكرت',
                                '${c.hotspotAveragePrice.toStringAsFixed(0)} ر.ي'),
                            _buildComparisonMetric('الحصة من المبيعات',
                                '${hsShare.toStringAsFixed(1)}%'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // User Manager Card
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: AppColors.navyPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'User Manager',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            _buildComparisonMetric(
                                'الكروت الكلية', '${c.userManTotalCards} كرت'),
                            _buildComparisonMetric(
                                'الكروت النشطة', '${c.userManActiveCards} كرت'),
                            _buildComparisonMetric('الإيراد التقديري',
                                '${c.userManRevenue.toStringAsFixed(0)} ر.ي'),
                            _buildComparisonMetric('متوسط سعر الكرت',
                                '${c.userManAveragePrice.toStringAsFixed(0)} ر.ي'),
                            _buildComparisonMetric('الحصة من المبيعات',
                                '${umShare.toStringAsFixed(1)}%'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Top Profiles Breakdown
              const Text(
                'الفئات (البروفايلات) الأكثر طلباً حسب النظام',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotspot Profiles
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('أعلى بروفايلات Hotspot',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.cyanAccent)),
                            const SizedBox(height: 8),
                            if (c.topHotspotProfiles.isEmpty)
                              const Text('لا توجد بيانات',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey))
                            else
                              ...c.topHotspotProfiles.entries.map((e) =>
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(e.key,
                                                style: const TextStyle(
                                                    fontSize: 11),
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Text('${e.value} كرت',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // User Manager Profiles
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('أعلى بروفايلات User Manager',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.navyPrimary)),
                            const SizedBox(height: 8),
                            if (c.topUserManProfiles.isEmpty)
                              const Text('لا توجد بيانات',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey))
                            else
                              ...c.topUserManProfiles.entries.map((e) =>
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(e.key,
                                                style: const TextStyle(
                                                    fontSize: 11),
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Text('${e.value} كرت',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComparisonMetric(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
          Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // =========================================================================
  // Tab 3: Direct Card Sales (المبيعات المباشرة)
  // =========================================================================

  Widget _buildDirectSalesTab(
      AsyncValue<List<CardSalesTableData>> cardSalesAsync) {
    return cardSalesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text('خطأ في تحميل المبيعات المباشرة: $e')),
      data: (sales) {
        // Filter sales
        final filtered = sales.where((s) {
          if (_directSalesSearch.isNotEmpty) {
            final query = _directSalesSearch.toLowerCase();
            if (!s.username.toLowerCase().contains(query) &&
                !(s.customerName?.toLowerCase().contains(query) ?? false) &&
                !s.profile.toLowerCase().contains(query)) {
              return false;
            }
          }
          switch (_directSalesFilter) {
            case 'hotspot':
              return s.cardType == 'hotspot';
            case 'usermanager':
              return s.cardType == 'usermanager';
            case 'printed':
              return s.isPrinted;
            case 'unprinted':
              return !s.isPrinted;
            case 'all':
            default:
              return true;
          }
        }).toList();

        final totalRevenue =
            filtered.fold<double>(0.0, (acc, s) => acc + s.price);
        final hsCount = filtered.where((s) => s.cardType == 'hotspot').length;
        final umCount =
            filtered.where((s) => s.cardType == 'usermanager').length;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.cyanAccent,
            foregroundColor: Colors.white,
            onPressed: () => _showAddSaleDialog(context),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('تسجيل عملية بيع'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Metric Bar
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'إجمالي المبيعات المباشرة',
                        '${filtered.length} عملية',
                        '${totalRevenue.toStringAsFixed(0)} ر.ي',
                        Icons.point_of_sale,
                        AppColors.cyanAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'مبيعات Hotspot',
                        '$hsCount كرت',
                        'مباشرة',
                        Icons.wifi,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'مبيعات User Manager',
                        '$umCount كرت',
                        'مباشرة',
                        Icons.manage_accounts,
                        AppColors.navyPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('كافة المبيعات'),
                        selected: _directSalesFilter == 'all',
                        onSelected: (val) {
                          if (val) setState(() => _directSalesFilter = 'all');
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Hotspot'),
                        selected: _directSalesFilter == 'hotspot',
                        onSelected: (val) {
                          if (val) {
                            setState(() => _directSalesFilter = 'hotspot');
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('User Manager'),
                        selected: _directSalesFilter == 'usermanager',
                        onSelected: (val) {
                          if (val) {
                            setState(() => _directSalesFilter = 'usermanager');
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('المطبوعة'),
                        selected: _directSalesFilter == 'printed',
                        onSelected: (val) {
                          if (val) {
                            setState(() => _directSalesFilter = 'printed');
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('غير المطبوعة'),
                        selected: _directSalesFilter == 'unprinted',
                        onSelected: (val) {
                          if (val) {
                            setState(() => _directSalesFilter = 'unprinted');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Search Bar
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'بحث باسم الكرت، البروفايل، أو العميل...',
                    prefixIcon: Icon(Icons.search, size: 20),
                    isDense: true,
                  ),
                  onChanged: (val) =>
                      setState(() => _directSalesSearch = val.trim()),
                ),
                const SizedBox(height: 12),

                // Sales List
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 36),
                    child: Center(
                      child: Text(
                          'لا توجد مبيعات مباشرة مسجلة مطابقة لهذا الفلتر.',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final item = filtered[idx];
                      final isUm = item.cardType == 'usermanager';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isUm
                                ? AppColors.navyPrimary.withValues(alpha: 0.15)
                                : AppColors.cyanAccent.withValues(alpha: 0.15),
                            child: Icon(
                              isUm ? Icons.manage_accounts : Icons.wifi,
                              color: isUm
                                  ? AppColors.navyPrimary
                                  : AppColors.cyanAccent,
                              size: 18,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(item.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isUm
                                      ? AppColors.navyPrimary
                                          .withValues(alpha: 0.1)
                                      : AppColors.cyanAccent
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isUm ? 'User Manager' : 'Hotspot',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isUm
                                        ? AppColors.navyPrimary
                                        : AppColors.cyanAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'الفئة: ${item.profile}  |  ${DateFormat('yyyy/MM/dd HH:mm').format(item.soldAt)}'
                            '${item.customerName != null ? " | العميل: ${item.customerName}" : ""}',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textSecondary),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${item.price.toStringAsFixed(0)} ر.ي',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.success)),
                              Text(
                                item.isPrinted ? 'مطبوع' : 'غير مطبوع',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: item.isPrinted
                                      ? AppColors.textSecondary
                                      : AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // Tab 4: Payments Management (التحصيلات الفعلية)
  // =========================================================================

  Widget _buildPaymentsTab(AsyncValue<List<PaymentsTableData>> paymentsAsync) {
    return paymentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ في تحميل التحصيلات: $e')),
      data: (payments) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            onPressed: () => _showAddPaymentDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('تسجيل تحصيل جديد'),
          ),
          body: payments.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payments_outlined,
                          size: 64, color: AppColors.textSecondary),
                      SizedBox(height: 16),
                      Text('لا توجد دفعات أو تحصيلات مالية مسجلة بعد.',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final item = payments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.success.withValues(alpha: 0.15),
                          child: const Icon(Icons.monetization_on,
                              color: AppColors.success),
                        ),
                        title: Text(
                          '${item.amount.toStringAsFixed(0)} ر.ي',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${item.note ?? "بدون ملاحظات"}  •  ${DateFormat('yyyy/MM/dd HH:mm').format(item.receivedAt)}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.danger),
                          tooltip: 'حذف التحصيل',
                          onPressed: () =>
                              _confirmDeletePayment(context, item.id),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // =========================================================================
  // Tab 3: Profile Prices (تسعير الفئات)
  // =========================================================================

  Widget _buildProfilePricesTab(AsyncValue<HonestReportData> reportAsync) {
    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ في تحميل الأسعار: $e')),
      data: (report) {
        final prices = report.profilePrices;
        final unpriced = report.stock.unpricedProfiles;
        final allProfiles = {...prices.keys, ...unpriced}.toList()..sort();

        if (allProfiles.isEmpty) {
          return const Center(
            child: Text('لا توجد فئات كروت بالراوتر حالياً.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: allProfiles.length,
          itemBuilder: (context, index) {
            final profile = allProfiles[index];
            final price = prices[profile];
            final isUnpriced = price == null || price == 0.0;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isUnpriced
                      ? AppColors.warning.withValues(alpha: 0.2)
                      : AppColors.cyanAccent.withValues(alpha: 0.2),
                  child: Icon(
                    isUnpriced
                        ? Icons.warning_amber_rounded
                        : Icons.label_important_outline,
                    color:
                        isUnpriced ? AppColors.warning : AppColors.cyanAccent,
                  ),
                ),
                title: Text(profile,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  isUnpriced
                      ? 'غير مسعر بعد'
                      : 'السعر الحالي: ${price.toStringAsFixed(0)} ر.ي',
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnpriced
                        ? AppColors.warning
                        : AppColors.textSecondary,
                  ),
                ),
                trailing: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBackground,
                    foregroundColor: AppColors.cyanAccent,
                  ),
                  onPressed: () =>
                      _showEditPriceDialog(context, profile, price ?? 0.0),
                  icon: const Icon(Icons.edit, size: 14),
                  label: Text(isUnpriced ? 'تحديد السعر' : 'تعديل'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================================
  // Tab 4: Audit Logs (سجل العمليات)
  // =========================================================================

  Widget _buildAuditLogsTab(AsyncValue auditLogsAsync) {
    return auditLogsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ في تحميل سجل العمليات: $e')),
      data: (logs) {
        if (logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_edu,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                const Text('لا توجد عمليات مسجلة في السجل',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
              ],
            ),
          );
        }

        final dateFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            final timeStr = dateFormat.format(log.performedAt);

            Color badgeColor;
            IconData iconData;
            switch (log.action) {
              case 'kick':
                badgeColor = AppColors.danger;
                iconData = Icons.power_settings_new;
                break;
              case 'delete':
                badgeColor = AppColors.warning;
                iconData = Icons.delete_outline;
                break;
              case 'generate':
                badgeColor = AppColors.success;
                iconData = Icons.flash_on;
                break;
              default:
                badgeColor = AppColors.cyanAccent;
                iconData = Icons.info_outline;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: badgeColor.withValues(alpha: 0.15),
                  child: Icon(iconData, color: badgeColor),
                ),
                title: Text(log.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('بواسطة: ${log.performedBy}  |  $timeStr',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                trailing: Chip(
                  label: Text(log.action,
                      style: TextStyle(
                          fontSize: 10,
                          color: badgeColor,
                          fontWeight: FontWeight.bold)),
                  backgroundColor: badgeColor.withValues(alpha: 0.1),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================================
  // Dialogs & Helpers
  // =========================================================================

  Widget _buildStatCard(String title, String mainValue, String subValue,
      IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(mainValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: color)),
            const SizedBox(height: 2),
            Text(subValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Text(title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesMetricTile(
      String label, String count, String value, bool isApprox) {
    return Column(
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(count,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.cyanAccent)),
        if (isApprox)
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text('(تاريخ تقريبي)',
                style: TextStyle(fontSize: 9, color: AppColors.warning)),
          ),
      ],
    );
  }

  void _showAddSaleDialog(BuildContext context) {
    String cardType = 'hotspot';
    final userCtrl = TextEditingController();
    final profileCtrl = TextEditingController(text: 'default');
    final priceCtrl = TextEditingController(text: '500');
    final customerCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.point_of_sale, color: AppColors.cyanAccent),
              SizedBox(width: 8),
              Text('تسجيل مبيعات كرت مباشرة'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Hotspot'),
                        selected: cardType == 'hotspot',
                        onSelected: (val) {
                          if (val) setDlgState(() => cardType = 'hotspot');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('User Manager'),
                        selected: cardType == 'usermanager',
                        onSelected: (val) {
                          if (val) setDlgState(() => cardType = 'usermanager');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: userCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم الكرت / الكود *',
                    prefixIcon: Icon(Icons.tag),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: profileCtrl,
                        decoration: const InputDecoration(
                          labelText: 'الفئة (البروفايل) *',
                          prefixIcon: Icon(Icons.folder_special),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'السعر (ر.ي) *',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: customerCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم العميل / المشترى (اختياري)',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم هاتف العميل (اختياري)',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات إضافية (اختياري)',
                    prefixIcon: Icon(Icons.note_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cyanAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final username = userCtrl.text.trim();
                final profile = profileCtrl.text.trim();
                final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                if (username.isEmpty || profile.isEmpty || price <= 0) return;

                final session = ref.read(sessionControllerProvider).session;
                final connectionId = session?.connectionId ?? 0;

                await ref.read(reportsRepositoryProvider).recordCardSale(
                      connectionId: connectionId,
                      cardType: cardType,
                      username: username,
                      profile: profile,
                      price: price,
                      soldBy: session?.username ?? 'admin',
                      customerName: customerCtrl.text.trim().isEmpty
                          ? null
                          : customerCtrl.text.trim(),
                      customerPhone: phoneCtrl.text.trim().isEmpty
                          ? null
                          : phoneCtrl.text.trim(),
                      notes: notesCtrl.text.trim().isEmpty
                          ? null
                          : notesCtrl.text.trim(),
                    );

                if (ctx.mounted) Navigator.pop(ctx);
                ref.invalidate(cardSalesListProvider);
                ref.invalidate(honestReportProvider);
              },
              child: const Text('تسجيل البيع'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل تحصيل مالي جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'المبلغ المستلم (ر.ي)',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'ملاحظات / اسم المسلم',
                prefixIcon: Icon(Icons.note),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text.trim());
              if (amount != null && amount > 0) {
                final session = ref.read(sessionControllerProvider).session;
                final connectionId = session?.connectionId ?? 0;
                await ref.read(reportsRepositoryProvider).addPayment(
                      connectionId: connectionId,
                      amount: amount,
                      note: noteController.text.trim().isEmpty
                          ? null
                          : noteController.text.trim(),
                    );
                if (ctx.mounted) Navigator.pop(ctx);
                ref.invalidate(honestReportProvider);
                ref.invalidate(paymentsListProvider);
              }
            },
            child: const Text('حفظ التحصيل'),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePayment(BuildContext context, int paymentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف التحصيل'),
        content: const Text('هل أنت متأكد من حذف هذا التحصيل المالي؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () async {
              await ref
                  .read(reportsRepositoryProvider)
                  .deletePayment(paymentId);
              if (ctx.mounted) Navigator.pop(ctx);
              ref.invalidate(honestReportProvider);
              ref.invalidate(paymentsListProvider);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showEditPriceDialog(
      BuildContext context, String profile, double currentPrice) {
    final priceController = TextEditingController(
        text: currentPrice > 0 ? currentPrice.toStringAsFixed(0) : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تسعير الفئة: $profile'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'السعر للكرت الواحد (ر.ي)',
            prefixIcon: Icon(Icons.monetization_on),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final price = double.tryParse(priceController.text.trim()) ?? 0.0;
              final session = ref.read(sessionControllerProvider).session;
              final connectionId = session?.connectionId ?? 0;
              await ref.read(reportsRepositoryProvider).setProfilePrice(
                    connectionId: connectionId,
                    profileName: profile,
                    price: price,
                  );
              if (ctx.mounted) Navigator.pop(ctx);
              ref.invalidate(honestReportProvider);
              ref.invalidate(profilePricesListProvider);
            },
            child: const Text('حفظ السعر'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Export PDF & CSV
  // =========================================================================

  void _exportPdfHonestReport(
      BuildContext context, HonestReportData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('MikroManager Pro - Honest Numbers Report',
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
                        style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Stock Inventory Summary:',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Bullet(
                  text:
                      'Unused Stock: ${data.stock.unusedCards} cards (Est. Value: ${data.stock.unusedValue.toStringAsFixed(0)} YER)'),
              pw.Bullet(
                  text:
                      'Active In-Use: ${data.stock.activeCards} cards (Est. Value: ${data.stock.activeValue.toStringAsFixed(0)} YER)'),
              pw.Bullet(text: 'Expired: ${data.stock.expiredCards} cards'),
              pw.SizedBox(height: 16),
              pw.Text('Estimated Sales (First Usage Observation):',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Bullet(
                  text:
                      'Today: ${data.sales.today.cardsCount} cards (${data.sales.today.totalEstimatedAmount.toStringAsFixed(0)} YER)'),
              pw.Bullet(
                  text:
                      'Last 7 Days: ${data.sales.last7Days.cardsCount} cards (${data.sales.last7Days.totalEstimatedAmount.toStringAsFixed(0)} YER)'),
              pw.Bullet(
                  text:
                      'Last 30 Days: ${data.sales.last30Days.cardsCount} cards (${data.sales.last30Days.totalEstimatedAmount.toStringAsFixed(0)} YER)'),
              pw.SizedBox(height: 16),
              pw.Text('Hotspot vs User Manager Comparison:',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Bullet(
                  text: 'Leading System: ${data.comparison.leadingSystem}'),
              pw.Bullet(
                  text:
                      'Hotspot Revenue: ${data.comparison.hotspotRevenue.toStringAsFixed(0)} YER (${data.comparison.hotspotTotalCards} cards)'),
              pw.Bullet(
                  text:
                      'User Manager Revenue: ${data.comparison.userManRevenue.toStringAsFixed(0)} YER (${data.comparison.userManTotalCards} cards)'),
              pw.SizedBox(height: 16),
              pw.Text('Reconciliation & Payments:',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Bullet(
                  text:
                      'Total Recorded Collections: ${data.payments.totalPayments.toStringAsFixed(0)} YER'),
              pw.Bullet(
                  text:
                      'Collection Balance (vs 30-day sales): ${data.payments.balance >= 0 ? "+" : ""}${data.payments.balance.toStringAsFixed(0)} YER'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'MikroManager_Honest_Report.pdf',
    );
  }

  void _exportCsvHonestReport(
      BuildContext context, HonestReportData data) async {
    final buffer = StringBuffer();
    buffer.writeln('Category,Metric,Value');
    buffer.writeln('Stock,Unused Cards,${data.stock.unusedCards}');
    buffer.writeln('Stock,Unused Value YER,${data.stock.unusedValue}');
    buffer.writeln('Stock,Active Cards,${data.stock.activeCards}');
    buffer.writeln('Stock,Active Value YER,${data.stock.activeValue}');
    buffer.writeln('Stock,Expired Cards,${data.stock.expiredCards}');
    buffer.writeln('Sales,Today Count,${data.sales.today.cardsCount}');
    buffer.writeln(
        'Sales,Today Estimated YER,${data.sales.today.totalEstimatedAmount}');
    buffer.writeln(
        'Sales,Last 30 Days Count,${data.sales.last30Days.cardsCount}');
    buffer.writeln(
        'Sales,Last 30 Days Estimated YER,${data.sales.last30Days.totalEstimatedAmount}');
    buffer
        .writeln('Payments,Total Collected YER,${data.payments.totalPayments}');
    buffer.writeln('Payments,Balance YER,${data.payments.balance}');
    buffer
        .writeln('Comparison,Leading System,${data.comparison.leadingSystem}');
    buffer.writeln(
        'Comparison,Hotspot Revenue YER,${data.comparison.hotspotRevenue}');
    buffer.writeln(
        'Comparison,Hotspot Cards,${data.comparison.hotspotTotalCards}');
    buffer.writeln(
        'Comparison,User Manager Revenue YER,${data.comparison.userManRevenue}');
    buffer.writeln(
        'Comparison,User Manager Cards,${data.comparison.userManTotalCards}');

    final bytes = Uint8List.fromList(utf8.encode(buffer.toString()));
    await Printing.sharePdf(
        bytes: bytes, filename: 'mikromanager_honest_report.csv');
  }
}
