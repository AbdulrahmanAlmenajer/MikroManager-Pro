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
    // Return empty fallback when session is not ready (e.g. preview/offline)
    return repo.getHonestReportData(
      connectionId: 0,
      subscribers: const [],
    );
  }

  // 1. Fetch real Hotspot subscribers from router
  List<SubscriberModel> subscribers = [];
  try {
    subscribers = await subscribersRepo.getHotspotSubscribers(session.adapter);
  } catch (_) {
    // Fallback if router fetch encounters temporary glitch
  }

  // 2. Automatically record first-use observations
  await repo.recordUsageObservations(
    connectionId: session.connectionId,
    subscribers: subscribers,
  );

  // 3. Reseller prefix scoping
  final String? resellerPrefix =
      session.role == UserRole.reseller ? session.username : null;

  // 4. Return aggregated honest report
  return await repo.getHonestReportData(
    connectionId: session.connectionId,
    subscribers: subscribers,
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
