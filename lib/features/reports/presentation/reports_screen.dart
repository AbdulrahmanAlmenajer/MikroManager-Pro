// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/constants/app_colors.dart';
import '../data/reports_repository.dart';
import '../domain/reports_notifier.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(salesSummaryProvider);
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
          tabs: const [
            Tab(icon: Icon(Icons.analytics_outlined), text: 'تقرير المبيعات'),
            Tab(icon: Icon(Icons.history_edu_outlined), text: 'سجل العمليات (Audit)'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'تصدير تقرير PDF',
            onPressed: () {
              summaryAsync.whenData((summary) => _exportPdfReport(context, summary));
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
            onPressed: () {
              ref.invalidate(salesSummaryProvider);
              ref.invalidate(auditLogsProvider);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSalesTab(summaryAsync),
          _buildAuditLogsTab(auditLogsAsync),
        ],
      ),
    );
  }

  Widget _buildSalesTab(AsyncValue<SalesSummary> summaryAsync) {
    return summaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ في تحميل المبيعات: $e')),
      data: (summary) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'إجمالي الإيرادات',
                      '${summary.totalRevenue.toStringAsFixed(0)} ر.ي',
                      Icons.account_balance_wallet,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      'الكروت المباعة',
                      '${summary.totalVouchers} كرت',
                      Icons.confirmation_number,
                      AppColors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      'صافي الأرباح',
                      '${summary.netProfit.toStringAsFixed(0)} ر.ي',
                      Icons.trending_up,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bar Chart: Sales By Profile
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('توزيع مبيعات الكروت حسب البروفايل',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: summary.vouchersByProfile.isEmpty
                            ? const Center(
                                child: Text('لا توجد مبيعات كروت مسجلة بعد',
                                    style: TextStyle(color: AppColors.textSecondary)),
                              )
                            : BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: (summary.vouchersByProfile.values.fold(0, (max, v) => v > max ? v : max) * 1.2)
                                      .toDouble(),
                                  titlesData: FlTitlesData(
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final keys = summary.vouchersByProfile.keys.toList();
                                          final idx = value.toInt();
                                          if (idx >= 0 && idx < keys.length) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(keys[idx], style: const TextStyle(fontSize: 10)),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: summary.vouchersByProfile.entries.toList().asMap().entries.map((entry) {
                                    return BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value.value.toDouble(),
                                          color: AppColors.cyanAccent,
                                          width: 18,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Breakdown Table
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('تفاصيل المبيعات حسب الفئة',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      if (summary.vouchersByProfile.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text('لا توجد بيانات متاحة حالياً',
                                style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        )
                      else
                        Table(
                          border: TableBorder.all(color: AppColors.border, borderRadius: BorderRadius.circular(8)),
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(color: AppColors.background),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('البروفايل',
                                      style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('العدد',
                                      style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                            ...summary.vouchersByProfile.entries.map(
                              (e) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(e.key, textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text('${e.value} كرت',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                Icon(Icons.history_edu, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                const Text('لا توجد عمليات مسجلة في السجل',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
                title: Text(log.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('بواسطة: ${log.performedBy}  |  $timeStr',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                trailing: Chip(
                  label: Text(log.action, style: TextStyle(fontSize: 10, color: badgeColor, fontWeight: FontWeight.bold)),
                  backgroundColor: badgeColor.withValues(alpha: 0.1),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
            const SizedBox(height: 2),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  void _exportPdfReport(BuildContext context, SalesSummary summary) async {
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
                    pw.Text('MikroManager Pro - Sales Report',
                        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(DateFormat('yyyy/MM/dd').format(DateTime.now()),
                        style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Financial Summary:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Bullet(text: 'Total Vouchers Generated: ${summary.totalVouchers}'),
              pw.Bullet(text: 'Total Revenue: ${summary.totalRevenue.toStringAsFixed(2)}'),
              pw.Bullet(text: 'Estimated Net Profit: ${summary.netProfit.toStringAsFixed(2)}'),
              pw.SizedBox(height: 24),
              pw.Text('Breakdown by Profile:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                context: context,
                headers: ['Profile', 'Quantity'],
                data: summary.vouchersByProfile.entries.map((e) => [e.key, e.value.toString()]).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'MikroManager_Sales_Report.pdf',
    );
  }
}
