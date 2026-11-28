import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/session/router_session.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/utils/cancellation_token.dart';
import '../../../core/widgets/task_progress_widget.dart';
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

final reportsProgressProvider =
    StateProvider<TaskProgressState?>((ref) => null);

final reportsCancellationTokenProvider =
    StateProvider<CancellationToken?>((ref) => null);

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

  final cancelToken = CancellationToken();
  ref.read(reportsCancellationTokenProvider.notifier).state = cancelToken;
  ref.onDispose(() {
    cancelToken.cancel();
    ref.read(reportsCancellationTokenProvider.notifier).state = null;
    ref.read(reportsProgressProvider.notifier).state = null;
  });

  // Stage 1: Fetching subscribers from router
  ref.read(reportsProgressProvider.notifier).state = const TaskProgressState(
    currentStage: 1,
    totalStages: 3,
    stageTitle: 'جلب بيانات المشتركين',
    detailText: 'سحب كروت Hotspot و User Manager من الراوتر...',
    progressPercent: 0.33,
  );
  cancelToken.throwIfCancelled();

  final List<SubscriberModel> allSubscribers = [];
  try {
    final hs = await subscribersRepo.getHotspotSubscribers(session.adapter);
    allSubscribers.addAll(hs);
  } catch (_) {
    // Graceful fallback if hotspot table is empty or error
  }

  cancelToken.throwIfCancelled();

  try {
    final um = await subscribersRepo.getUserManSubscribers(session.adapter);
    allSubscribers.addAll(um);
  } catch (_) {
    // Graceful fallback if userman is not installed or empty
  }

  cancelToken.throwIfCancelled();

  // Stage 2: Background processing and observations
  ref.read(reportsProgressProvider.notifier).state = const TaskProgressState(
    currentStage: 2,
    totalStages: 3,
    stageTitle: 'معالجة البيانات في المعالج المستقل',
    detailText: 'تسجيل أول استخدام ومطابقة المبيعات وحساب الإحصائيات...',
    progressPercent: 0.66,
  );

  await repo.recordUsageObservations(
    connectionId: session.connectionId,
    subscribers: allSubscribers,
  );

  cancelToken.throwIfCancelled();

  final String? resellerPrefix =
      session.role == UserRole.reseller ? session.username : null;

  final result = await repo.getHonestReportData(
    connectionId: session.connectionId,
    subscribers: allSubscribers,
    resellerPrefix: resellerPrefix,
  );

  cancelToken.throwIfCancelled();

  // Stage 3: Complete
  ref.read(reportsProgressProvider.notifier).state = null;
  return result;
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
