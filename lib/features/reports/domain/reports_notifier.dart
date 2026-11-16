import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../data/reports_repository.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ReportsRepository(db);
});

final salesSummaryProvider = FutureProvider<SalesSummary>((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  return await repo.getSalesSummary();
});

final auditLogsProvider = FutureProvider((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  return await repo.getAuditLogs();
});
