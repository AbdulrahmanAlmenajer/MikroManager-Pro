import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/network/routeros_adapter.dart';
import '../../../core/session/session_controller.dart';
import '../data/ap_repository.dart';

final apRepositoryProvider = Provider<ApRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ApRepository(db);
});

class ApState {
  final List<ApDevicesTableData> devices;
  final bool isLoading;
  final bool isDiscovering;
  final List<DiscoveredNeighbor> discovered;
  final String? errorMessage;

  const ApState({
    this.devices = const [],
    this.isLoading = false,
    this.isDiscovering = false,
    this.discovered = const [],
    this.errorMessage,
  });

  ApState copyWith({
    List<ApDevicesTableData>? devices,
    bool? isLoading,
    bool? isDiscovering,
    List<DiscoveredNeighbor>? discovered,
    String? errorMessage,
  }) {
    return ApState(
      devices: devices ?? this.devices,
      isLoading: isLoading ?? this.isLoading,
      isDiscovering: isDiscovering ?? this.isDiscovering,
      discovered: discovered ?? this.discovered,
      errorMessage: errorMessage,
    );
  }
}

class ApNotifier extends StateNotifier<ApState> {
  final ApRepository _repo;

  ApNotifier(this._repo) : super(const ApState());

  Future<void> loadDevices(int connectionId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repo.getAllAps(connectionId);
      state = state.copyWith(devices: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'تعذر تحميل الأجهزة: $e');
    }
  }

  Future<void> discoverNeighbors(RouterOsAdapter adapter) async {
    state = state.copyWith(isDiscovering: true, errorMessage: null);
    try {
      final neighbors = await _repo.discoverNeighbors(adapter);
      state = state.copyWith(discovered: neighbors, isDiscovering: false);
    } catch (e) {
      state = state.copyWith(isDiscovering: false, errorMessage: 'فشل اكتشاف الجيران: $e');
    }
  }

  Future<bool> addDiscovered(
    int connectionId,
    DiscoveredNeighbor neighbor, {
    String? username,
    String? password,
  }) async {
    try {
      await _repo.addAp(
        connectionId: connectionId,
        name: neighbor.identity,
        ip: neighbor.ip,
        vendor: neighbor.vendor,
        username: username,
        password: password,
      );
      await loadDevices(connectionId);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'تعذر إضافة نقطة البث: $e');
      return false;
    }
  }

  Future<bool> addManual({
    required int connectionId,
    required String name,
    required String ip,
    required String vendor,
    String? username,
    String? password,
  }) async {
    try {
      await _repo.addAp(
        connectionId: connectionId,
        name: name,
        ip: ip,
        vendor: vendor,
        username: username,
        password: password,
      );
      await loadDevices(connectionId);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'تعذر إضافة نقطة البث: $e');
      return false;
    }
  }

  Future<bool> deleteDevice(int id, int connectionId) async {
    try {
      await _repo.deleteAp(id);
      await loadDevices(connectionId);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'تعذر حذف نقطة البث: $e');
      return false;
    }
  }

  Future<void> checkAllHealth(int connectionId) async {
    final list = [...state.devices];
    for (final device in list) {
      await _repo.refreshApState(device.id, device.ip);
    }
    await loadDevices(connectionId);
  }
}

final apNotifierProvider = StateNotifierProvider<ApNotifier, ApState>((ref) {
  final repo = ref.watch(apRepositoryProvider);
  final notifier = ApNotifier(repo);

  final session = ref.watch(sessionControllerProvider).session;
  if (session != null) {
    notifier.loadDevices(session.connectionId);
  }

  return notifier;
});
