import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/routers_repository.dart';

final routersRepositoryProvider = Provider<RoutersRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return RoutersRepository(db);
});

final routersStreamProvider = StreamProvider<List<RoutersTableData>>((ref) {
  final repo = ref.watch(routersRepositoryProvider);
  return repo.watchAllRouters();
});

class RouterState {
  final RoutersTableData? activeRouter;
  final bool isConnecting;
  final bool isConnected;
  final String? errorMessage;

  RouterState({
    this.activeRouter,
    this.isConnecting = false,
    this.isConnected = false,
    this.errorMessage,
  });

  RouterState copyWith({
    RoutersTableData? activeRouter,
    bool? isConnecting,
    bool? isConnected,
    String? errorMessage,
  }) {
    return RouterState(
      activeRouter: activeRouter ?? this.activeRouter,
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: errorMessage,
    );
  }
}

class RoutersNotifier extends StateNotifier<RouterState> {
  final RoutersRepository _repo;

  RoutersNotifier(this._repo) : super(RouterState()) {
    _initActiveRouter();
  }

  Future<void> _initActiveRouter() async {
    final routers = await _repo.getAllRouters();
    final active = routers.where((r) => r.isActive).firstOrNull;
    if (active != null) {
      state = state.copyWith(activeRouter: active);
    }
  }

  Future<int> addRouter({
    required String name,
    required String ipAddress,
    required int apiPort,
    required String username,
    required String password,
    bool useSsl = false,
    bool useRestApi = false,
    String? notes,
  }) async {
    final id = await _repo.addRouter(
      name: name,
      ipAddress: ipAddress,
      apiPort: apiPort,
      username: username,
      password: password,
      useSsl: useSsl,
      useRestApi: useRestApi,
      notes: notes,
    );
    // If first router, make it active
    final all = await _repo.getAllRouters();
    if (all.length == 1) {
      await selectActiveRouter(all.first);
    }
    return id;
  }

  Future<bool> updateRouter({
    required int id,
    required String name,
    required String ipAddress,
    required int apiPort,
    required String username,
    String? password,
    bool useSsl = false,
    bool useRestApi = false,
    String? notes,
  }) async {
    final success = await _repo.updateRouter(
      id: id,
      name: name,
      ipAddress: ipAddress,
      apiPort: apiPort,
      username: username,
      password: password,
      useSsl: useSsl,
      useRestApi: useRestApi,
      notes: notes,
    );
    if (state.activeRouter?.id == id) {
      final updated = await _repo.getRouterById(id);
      if (updated != null) {
        state = state.copyWith(activeRouter: updated);
      }
    }
    return success;
  }

  Future<bool> deleteRouter(int id) async {
    final success = await _repo.deleteRouter(id);
    if (state.activeRouter?.id == id) {
      final all = await _repo.getAllRouters();
      state = state.copyWith(activeRouter: all.firstOrNull, isConnected: false);
    }
    return success;
  }

  Future<void> selectActiveRouter(RoutersTableData router) async {
    await _repo.setActiveRouter(router.id);
    state = state.copyWith(activeRouter: router, isConnected: false);
  }

  Future<bool> testConnection({
    required String ipAddress,
    required int apiPort,
    required String username,
    required String password,
    bool useSsl = false,
    bool useRestApi = false,
  }) async {
    return await _repo.testRouterConnection(
      ipAddress: ipAddress,
      apiPort: apiPort,
      username: username,
      password: password,
      useSsl: useSsl,
      useRestApi: useRestApi,
    );
  }
}

final routersControllerProvider = StateNotifierProvider<RoutersNotifier, RouterState>((ref) {
  final repo = ref.watch(routersRepositoryProvider);
  return RoutersNotifier(repo);
});
