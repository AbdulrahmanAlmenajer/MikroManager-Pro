import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';

class SalesSummary {
  final int totalVouchers;
  final double totalRevenue;
  final double totalCost;
  final double netProfit;
  final Map<String, int> vouchersByProfile;
  final Map<String, double> revenueByDate;

  SalesSummary({
    required this.totalVouchers,
    required this.totalRevenue,
    required this.totalCost,
    required this.netProfit,
    required this.vouchersByProfile,
    required this.revenueByDate,
  });
}

class ReportsRepository {
  final AppDatabase _db;

  ReportsRepository(this._db);

  Future<SalesSummary> getSalesSummary() async {
    final batches = await _db.select(_db.voucherBatchesTable).get();

    int totalVouchers = 0;
    double totalRevenue = 0.0;
    final Map<String, int> byProfile = {};
    final Map<String, double> byDate = {};

    for (final b in batches) {
      totalVouchers += b.quantity;
      totalRevenue += b.totalAmount;

      // Profile
      byProfile[b.profileName] = (byProfile[b.profileName] ?? 0) + b.quantity;

      // Date (yyyy-MM-dd)
      final dateKey =
          '${b.generatedAt.year}-${b.generatedAt.month.toString().padLeft(2, '0')}-${b.generatedAt.day.toString().padLeft(2, '0')}';
      byDate[dateKey] = (byDate[dateKey] ?? 0.0) + b.totalAmount;
    }

    // Cost estimation (e.g. 10% operational or configurable)
    final totalCost = totalRevenue * 0.1;
    final netProfit = totalRevenue - totalCost;

    return SalesSummary(
      totalVouchers: totalVouchers,
      totalRevenue: totalRevenue,
      totalCost: totalCost,
      netProfit: netProfit,
      vouchersByProfile: byProfile,
      revenueByDate: byDate,
    );
  }

  Future<List<AuditLogsTableData>> getAuditLogs() async {
    return await (_db.select(_db.auditLogsTable)
          ..orderBy([(t) => OrderingTerm(expression: t.performedAt, mode: OrderingMode.desc)])
          ..limit(50))
        .get();
  }
}
