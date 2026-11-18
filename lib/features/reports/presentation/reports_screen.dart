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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
  // Tab 2: Payments Management (التحصيلات الفعلية)
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

    final bytes = Uint8List.fromList(utf8.encode(buffer.toString()));
    await Printing.sharePdf(
        bytes: bytes, filename: 'mikromanager_honest_report.csv');
  }
}
