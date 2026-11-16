import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/utils/audit_logger.dart';
import '../../routers/domain/active_router_provider.dart';
import '../data/hotspot_repository.dart';

final auditLoggerProvider = Provider<AuditLogger>((ref) {
  final db = ref.watch(databaseProvider);
  return AuditLogger(db);
});

final hotspotRepositoryProvider = Provider<HotspotRepository>((ref) {
  final logger = ref.watch(auditLoggerProvider);
  return HotspotRepository(logger);
});

class HotspotState {
  final List<Map<String, dynamic>> activeUsers;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> profiles;
  final bool isLoading;
  final String? errorMessage;

  HotspotState({
    this.activeUsers = const [],
    this.users = const [],
    this.profiles = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  HotspotState copyWith({
    List<Map<String, dynamic>>? activeUsers,
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? profiles,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HotspotState(
      activeUsers: activeUsers ?? this.activeUsers,
      users: users ?? this.users,
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HotspotNotifier extends StateNotifier<HotspotState> {
  final Ref _ref;
  final HotspotRepository _repo;

  HotspotNotifier(this._ref, this._repo) : super(HotspotState()) {
    refreshAll();
  }

  Future<void> refreshAll() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'لا يوجد راوتر محدد حالياً');
        return;
      }

      final active = await _repo.getActiveUsers(adapter);
      final users = await _repo.getUsers(adapter);
      final profiles = await _repo.getProfiles(adapter);

      state = state.copyWith(
        activeUsers: active,
        users: users,
        profiles: profiles,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> addUser({
    required String name,
    required String password,
    required String profile,
    String? limitUptime,
    String? limitBytesTotal,
    String? comment,
  }) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success = await _repo.addUser(
        adapter: adapter,
        name: name,
        password: password,
        profile: profile,
        limitUptime: limitUptime,
        limitBytesTotal: limitBytesTotal,
        comment: comment,
      );

      if (success) {
        await refreshAll();
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeUser(String id, String username) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success = await _repo.removeUser(adapter: adapter, id: id, username: username);
      if (success) {
        await refreshAll();
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> kickUser(String id, String username) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success = await _repo.kickUser(adapter: adapter, id: id, username: username);
      if (success) {
        await refreshAll();
      }
      return success;
    } catch (_) {
      return false;
    }
  }
}

final hotspotControllerProvider = StateNotifierProvider<HotspotNotifier, HotspotState>((ref) {
  final repo = ref.watch(hotspotRepositoryProvider);
  return HotspotNotifier(ref, repo);
});
