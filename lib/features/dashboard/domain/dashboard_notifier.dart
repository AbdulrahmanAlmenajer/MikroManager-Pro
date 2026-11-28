import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../routers/domain/active_router_provider.dart';
import '../../routers/domain/routers_notifier.dart';
import '../data/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

class DashboardKpiData {
  final double totalSalesAmount;
  final int generatedLast30Days;
  final int soldCardsCount;
  final int remainingCardsCount;

  const DashboardKpiData({
    this.totalSalesAmount = 0.0,
    this.generatedLast30Days = 0,
    this.soldCardsCount = 0,
    this.remainingCardsCount = 0,
  });
}

final dashboardKpiProvider =
    FutureProvider.autoDispose<DashboardKpiData>((ref) async {
  final db = ref.watch(databaseProvider);
  final routerState = ref.watch(routersControllerProvider);
  final activeRouter = routerState.activeRouter;
  final connId = activeRouter?.id ?? 1;

  try {
    final sales = await (db.select(db.cardSalesTable)
          ..where((t) => t.connectionId.equals(connId)))
        .get();
    final totalSales = sales.fold<double>(0.0, (acc, s) => acc + s.price);
    final soldCount = sales.length;

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final batches = await (db.select(db.voucherBatchesTable)
          ..where((t) =>
              t.routerId.equals(connId) &
              t.generatedAt.isBiggerOrEqualValue(thirtyDaysAgo)))
        .get();
    final generatedCount =
        batches.fold<int>(0, (acc, b) => acc + b.quantity);

    final remaining = (generatedCount - soldCount).clamp(0, 999999);

    return DashboardKpiData(
      totalSalesAmount: totalSales,
      generatedLast30Days: generatedCount,
      soldCardsCount: soldCount,
      remainingCardsCount: remaining,
    );
  } catch (_) {
    return const DashboardKpiData();
  }
});

class TrafficDataPoint {
  final double time;
  final double rxMbps;
  final double txMbps;

  TrafficDataPoint(
      {required this.time, required this.rxMbps, required this.txMbps});
}

class DashboardState {
  final String cpuLoad;
  final String freeMemory;
  final String totalMemory;
  final String uptime;
  final String boardName;
  final String version;
  final int activeUsersCount;
  final List<TrafficDataPoint> trafficHistory;
  final double currentRxMbps;
  final double currentTxMbps;
  final bool isLoading;
  final bool isConnected;
  final String? selectedInterface;
  final List<String> availableInterfaces;

  DashboardState({
    this.cpuLoad = '0%',
    this.freeMemory = '0 MB',
    this.totalMemory = '0 MB',
    this.uptime = '-',
    this.boardName = 'MikroTik',
    this.version = '-',
    this.activeUsersCount = 0,
    this.trafficHistory = const [],
    this.currentRxMbps = 0.0,
    this.currentTxMbps = 0.0,
    this.isLoading = false,
    this.isConnected = false,
    this.selectedInterface,
    this.availableInterfaces = const [],
  });

  DashboardState copyWith({
    String? cpuLoad,
    String? freeMemory,
    String? totalMemory,
    String? uptime,
    String? boardName,
    String? version,
    int? activeUsersCount,
    List<TrafficDataPoint>? trafficHistory,
    double? currentRxMbps,
    double? currentTxMbps,
    bool? isLoading,
    bool? isConnected,
    String? selectedInterface,
    List<String>? availableInterfaces,
  }) {
    return DashboardState(
      cpuLoad: cpuLoad ?? this.cpuLoad,
      freeMemory: freeMemory ?? this.freeMemory,
      totalMemory: totalMemory ?? this.totalMemory,
      uptime: uptime ?? this.uptime,
      boardName: boardName ?? this.boardName,
      version: version ?? this.version,
      activeUsersCount: activeUsersCount ?? this.activeUsersCount,
      trafficHistory: trafficHistory ?? this.trafficHistory,
      currentRxMbps: currentRxMbps ?? this.currentRxMbps,
      currentTxMbps: currentTxMbps ?? this.currentTxMbps,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      selectedInterface: selectedInterface ?? this.selectedInterface,
      availableInterfaces: availableInterfaces ?? this.availableInterfaces,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Ref _ref;
  final DashboardRepository _repo;
  Timer? _timer;
  double _timeCounter = 0;

  DashboardNotifier(this._ref, this._repo) : super(DashboardState()) {
    initDashboard();
  }

  Future<void> initDashboard() async {
    state = state.copyWith(isLoading: true);
    await refreshMetrics();
    _startPolling();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      refreshMetrics(silent: true);
    });
  }

  Future<void> refreshMetrics({bool silent = false}) async {
    if (!silent) state = state.copyWith(isLoading: true);

    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) {
        state = state.copyWith(isLoading: false, isConnected: false);
        return;
      }

      final res = await _repo.getSystemResource(adapter);
      final activeCount = await _repo.getActiveUsersCount(adapter);

      // Extract system resources
      final cpu = res['cpu-load'] != null ? '${res['cpu-load']}%' : '0%';
      final freeMemBytes =
          int.tryParse(res['free-memory']?.toString() ?? '0') ?? 0;
      final totalMemBytes =
          int.tryParse(res['total-memory']?.toString() ?? '0') ?? 0;
      final freeMemMb = (freeMemBytes / (1024 * 1024)).toStringAsFixed(1);
      final totalMemMb = (totalMemBytes / (1024 * 1024)).toStringAsFixed(1);
      final uptime = res['uptime']?.toString() ?? '-';
      final board = res['board-name']?.toString() ?? 'MikroTik Router';
      final version = res['version']?.toString() ?? '-';

      // Load interfaces if not yet loaded
      List<String> interfaces = state.availableInterfaces;
      String? currentInterface = state.selectedInterface;

      if (interfaces.isEmpty) {
        final ifaceList = await _repo.getInterfaces(adapter);
        interfaces = ifaceList
            .map((i) => i['name']?.toString() ?? '')
            .where((n) => n.isNotEmpty)
            .toList();
        if (interfaces.isNotEmpty) {
          currentInterface = interfaces.first;
        }
      }

      // Fetch traffic if interface selected
      double rxMbps = 0.0;
      double txMbps = 0.0;
      if (currentInterface != null) {
        final traffic = await _repo.getTraffic(adapter, currentInterface);
        rxMbps = ((traffic['rx'] ?? 0) / 1000000.0);
        txMbps = ((traffic['tx'] ?? 0) / 1000000.0);
      }

      _timeCounter += 1;
      final newPoint = TrafficDataPoint(
        time: _timeCounter,
        rxMbps: double.parse(rxMbps.toStringAsFixed(2)),
        txMbps: double.parse(txMbps.toStringAsFixed(2)),
      );

      final updatedHistory = List<TrafficDataPoint>.from(state.trafficHistory);
      if (updatedHistory.length >= 15) {
        updatedHistory.removeAt(0);
      }
      updatedHistory.add(newPoint);

      state = state.copyWith(
        cpuLoad: cpu,
        freeMemory: '$freeMemMb MB',
        totalMemory: '$totalMemMb MB',
        uptime: uptime,
        boardName: board,
        version: version,
        activeUsersCount: activeCount,
        trafficHistory: updatedHistory,
        currentRxMbps: rxMbps,
        currentTxMbps: txMbps,
        availableInterfaces: interfaces,
        selectedInterface: currentInterface,
        isConnected: true,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, isConnected: false);
    }
  }

  void selectInterface(String interfaceName) {
    state =
        state.copyWith(selectedInterface: interfaceName, trafficHistory: []);
    refreshMetrics(silent: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}

final dashboardControllerProvider =
    StateNotifierProvider.autoDispose<DashboardNotifier, DashboardState>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(ref, repo);
});
