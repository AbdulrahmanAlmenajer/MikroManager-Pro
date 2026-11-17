import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/session/session_controller.dart';
import '../data/dashboard_repository.dart';
import 'dashboard_notifier.dart';

class InterfacesTrafficState {
  final List<InterfaceModel> interfaces;
  final String? selectedInterface;
  final List<TrafficDataPoint> trafficHistory;
  final double currentRxMbps;
  final double currentTxMbps;
  final bool isLoading;
  final String? errorMessage;
  final bool isRecordingDaily;

  const InterfacesTrafficState({
    this.interfaces = const [],
    this.selectedInterface,
    this.trafficHistory = const [],
    this.currentRxMbps = 0.0,
    this.currentTxMbps = 0.0,
    this.isLoading = false,
    this.errorMessage,
    this.isRecordingDaily = false,
  });

  InterfacesTrafficState copyWith({
    List<InterfaceModel>? interfaces,
    String? selectedInterface,
    List<TrafficDataPoint>? trafficHistory,
    double? currentRxMbps,
    double? currentTxMbps,
    bool? isLoading,
    String? errorMessage,
    bool? isRecordingDaily,
  }) {
    return InterfacesTrafficState(
      interfaces: interfaces ?? this.interfaces,
      selectedInterface: selectedInterface ?? this.selectedInterface,
      trafficHistory: trafficHistory ?? this.trafficHistory,
      currentRxMbps: currentRxMbps ?? this.currentRxMbps,
      currentTxMbps: currentTxMbps ?? this.currentTxMbps,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isRecordingDaily: isRecordingDaily ?? this.isRecordingDaily,
    );
  }
}

class InterfacesTrafficNotifier extends StateNotifier<InterfacesTrafficState> {
  final Ref _ref;
  final DashboardRepository _repo;
  StreamSubscription<Map<String, int>>? _trafficSubscription;
  Timer? _refreshTimer;
  double _timeCounter = 0;

  InterfacesTrafficNotifier(this._ref, this._repo) : super(const InterfacesTrafficState()) {
    loadInterfaces();
  }

  Future<void> loadInterfaces() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = _ref.read(sessionControllerProvider).session;
      if (session == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'لا توجد جلسة راوتر نشطة');
        return;
      }

      final list = await _repo.getDetailedInterfaces(session.adapter);
      String? defaultSelected = state.selectedInterface;
      if (defaultSelected == null && list.isNotEmpty) {
        defaultSelected = list.first.name;
      }

      state = state.copyWith(
        interfaces: list,
        selectedInterface: defaultSelected,
        isLoading: false,
      );

      if (defaultSelected != null) {
        _startMonitoring(defaultSelected);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'فشل تحميل بيانات الواجهات: ${e.toString()}',
      );
    }
  }

  void selectInterface(String name) {
    if (state.selectedInterface == name) return;
    state = state.copyWith(
      selectedInterface: name,
      trafficHistory: [],
      currentRxMbps: 0.0,
      currentTxMbps: 0.0,
    );
    _startMonitoring(name);
  }

  void _startMonitoring(String interfaceName) {
    _trafficSubscription?.cancel();
    _refreshTimer?.cancel();

    final session = _ref.read(sessionControllerProvider).session;
    if (session == null) return;

    // Use scheduler polling stream to prevent redundant queries and backoff on errors
    final stream = session.scheduler.registerPollingStream<Map<String, int>>(
      key: 'traffic_$interfaceName',
      interval: const Duration(seconds: 2),
      fetcher: () => _repo.getTraffic(session.adapter, interfaceName),
    );

    _trafficSubscription = stream.listen((traffic) {
      final rxMbps = (traffic['rx'] ?? 0) / 1000000.0;
      final txMbps = (traffic['tx'] ?? 0) / 1000000.0;

      _timeCounter += 1;
      final point = TrafficDataPoint(
        time: _timeCounter,
        rxMbps: double.parse(rxMbps.toStringAsFixed(2)),
        txMbps: double.parse(txMbps.toStringAsFixed(2)),
      );

      final updatedHistory = List<TrafficDataPoint>.from(state.trafficHistory);
      if (updatedHistory.length >= 20) {
        updatedHistory.removeAt(0);
      }
      updatedHistory.add(point);

      if (mounted) {
        state = state.copyWith(
          trafficHistory: updatedHistory,
          currentRxMbps: rxMbps,
          currentTxMbps: txMbps,
        );
      }
    }, onError: (_) {});
  }

  Future<void> saveSnapshotToDaily() async {
    final session = _ref.read(sessionControllerProvider).session;
    final iface = state.selectedInterface;
    if (session == null || iface == null) return;

    state = state.copyWith(isRecordingDaily: true);
    try {
      final db = _ref.read(databaseProvider);
      final currentModel = state.interfaces.where((i) => i.name == iface).firstOrNull;

      await _repo.recordDailySnapshot(
        db,
        connectionId: session.connectionId,
        interfaceName: iface,
        rxBytes: currentModel?.rxBytes ?? 0,
        txBytes: currentModel?.txBytes ?? 0,
      );
    } finally {
      if (mounted) {
        state = state.copyWith(isRecordingDaily: false);
      }
    }
  }

  @override
  void dispose() {
    _trafficSubscription?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }
}

final interfacesTrafficProvider =
    StateNotifierProvider.autoDispose<InterfacesTrafficNotifier, InterfacesTrafficState>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return InterfacesTrafficNotifier(ref, repo);
});
