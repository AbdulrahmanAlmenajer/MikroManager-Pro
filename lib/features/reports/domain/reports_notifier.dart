import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/session/router_session.dart';
import '../../../core/session/session_controller.dart';
import '../../subscribers/data/subscribers_repository.dart';
import '../../subscribers/domain/subscribers_notifier.dart';
import '../data/reports_repository.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ReportsRepository(db);
});

final salesSummaryProvider = FutureProvider<SalesSummary>((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  return await repo.getSalesSummary();
});

final auditLogsProvider = FutureProvider<List<AuditLogsTableData>>((ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  return await repo.getAuditLogs();
});

final honestReportProvider =
    FutureProvider.autoDispose<HonestReportData>((ref) async {
  final session = ref.watch(sessionControllerProvider).session;
  final repo = ref.watch(reportsRepositoryProvider);
  final subscribersRepo = ref.watch(subscribersRepositoryProvider);

  if (session == null) {
    return repo.getHonestReportData(
      connectionId: 0,
      subscribers: const [],
    );
  }

  // 1. Fetch BOTH Hotspot and User Manager subscribers from router
  final List<SubscriberModel> allSubscribers = [];
  try {
    final hs = await subscribersRepo.getHotspotSubscribers(session.adapter);
    allSubscribers.addAll(hs);
  } catch (_) {
    // Graceful fallback if hotspot table is empty or error
  }

  try {
    final um = await subscribersRepo.getUserManSubscribers(session.adapter);
    allSubscribers.addAll(um);
  } catch (_) {
    // Graceful fallback if userman is not installed or empty
  }

  // 2. Automatically record first-use observations
  await repo.recordUsageObservations(
    connectionId: session.connectionId,
    subscribers: allSubscribers,
  );

  // 3. Reseller prefix scoping
  final String? resellerPrefix =
      session.role == UserRole.reseller ? session.username : null;

  // 4. Return aggregated honest report with Hotspot and User Manager breakdown
  return await repo.getHonestReportData(
    connectionId: session.connectionId,
    subscribers: allSubscribers,
    resellerPrefix: resellerPrefix,
  );
});

final profilePricesListProvider =
    FutureProvider.autoDispose<List<ProfilePricesTableData>>((ref) async {
  final session = ref.watch(sessionControllerProvider).session;
  final repo = ref.watch(reportsRepositoryProvider);
  if (session == null) return [];
  return await repo.getAllProfilePriceRecords(session.connectionId);
});

final paymentsListProvider =
    FutureProvider.autoDispose<List<PaymentsTableData>>((ref) async {
  final session = ref.watch(sessionControllerProvider).session;
  final repo = ref.watch(reportsRepositoryProvider);
  if (session == null) return [];
  return await repo.getPayments(session.connectionId);
});

final cardSalesListProvider =
    FutureProvider.autoDispose<List<CardSalesTableData>>((ref) async {
  final session = ref.watch(sessionControllerProvider).session;
  final repo = ref.watch(reportsRepositoryProvider);
  if (session == null) return [];
  return await repo.getCardSales(session.connectionId);
});
