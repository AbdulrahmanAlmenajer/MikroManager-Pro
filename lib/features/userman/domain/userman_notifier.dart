import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../hotspot/domain/hotspot_notifier.dart';
import '../../routers/domain/active_router_provider.dart';
import '../data/userman_repository.dart';

final usermanRepositoryProvider = Provider<UsermanRepository>((ref) {
  final logger = ref.watch(auditLoggerProvider);
  return UsermanRepository(logger);
});

class UsermanState {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> profiles;
  final List<Map<String, dynamic>> sessions;
  final bool isLoading;
  final String? errorMessage;

  UsermanState({
    this.users = const [],
    this.profiles = const [],
    this.sessions = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  UsermanState copyWith({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? profiles,
    List<Map<String, dynamic>>? sessions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UsermanState(
      users: users ?? this.users,
      profiles: profiles ?? this.profiles,
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class UsermanNotifier extends StateNotifier<UsermanState> {
  final Ref _ref;
  final UsermanRepository _repo;

  UsermanNotifier(this._ref, this._repo) : super(UsermanState()) {
    refreshAll();
  }

  Future<void> refreshAll() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) {
        state = state.copyWith(
            isLoading: false, errorMessage: 'لا يوجد راوتر محدد حالياً');
        return;
      }

      final users = await _repo.getUsers(adapter);
      final profiles = await _repo.getProfiles(adapter);
      final sessions = await _repo.getSessions(adapter);

      state = state.copyWith(
        users: users,
        profiles: profiles,
        sessions: sessions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> addUser({
    required String username,
    required String password,
    String? profile,
    String? comment,
  }) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success = await _repo.addUser(
        adapter: adapter,
        username: username,
        password: password,
        profile: profile,
        comment: comment,
      );

      if (success) {
        await refreshAll();
      }
      return success;
    } on Exception catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: 'فشل إضافة المستخدم: ${e.toString()}');
      return false;
    }
  }

  Future<bool> removeUser(String id, String username) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success =
          await _repo.removeUser(adapter: adapter, id: id, username: username);
      if (success) {
        await refreshAll();
      }
      return success;
    } on Exception catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'فشل حذف المستخدم: ${e.toString()}');
      return false;
    }
  }

  Future<bool> kickSession(String id, String username) async {
    try {
      final adapter = await _ref.read(activeAdapterProvider.future);
      if (adapter == null) return false;

      final success =
          await _repo.kickSession(adapter: adapter, id: id, username: username);
      if (success) {
        await refreshAll();
      }
      return success;
    } on Exception catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'فشل إنهاء الجلسة: ${e.toString()}');
      return false;
    }
  }
}

final usermanControllerProvider =
    StateNotifierProvider<UsermanNotifier, UsermanState>((ref) {
  final repo = ref.watch(usermanRepositoryProvider);
  return UsermanNotifier(ref, repo);
});
