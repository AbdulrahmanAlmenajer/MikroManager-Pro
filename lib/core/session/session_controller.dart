import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/routeros_adapter.dart';
import '../network/routeros_exceptions.dart';
import '../security/secure_storage_service.dart';
import '../../features/routers/domain/routers_notifier.dart';
import '../../features/routers/data/routers_repository.dart';
import 'router_session.dart';

enum SessionStatus {
  unauthenticated,
  connecting,
  authenticated,
  error,
}

class SessionState {
  final SessionStatus status;
  final RouterSession? session;
  final String? errorMessage;
  final int failedAttempts;
  final DateTime? lockedUntil;

  const SessionState({
    this.status = SessionStatus.unauthenticated,
    this.session,
    this.errorMessage,
    this.failedAttempts = 0,
    this.lockedUntil,
  });

  bool get isAuthenticated => status == SessionStatus.authenticated && session != null;
  bool get isConnecting => status == SessionStatus.connecting;
  bool get isLocked {
    if (lockedUntil == null) return false;
    return DateTime.now().isBefore(lockedUntil!);
  }

  int get remainingLockSeconds {
    if (lockedUntil == null) return 0;
    final diff = lockedUntil!.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  SessionState copyWith({
    SessionStatus? status,
    RouterSession? session,
    String? errorMessage,
    int? failedAttempts,
    DateTime? lockedUntil,
    bool clearSession = false,
  }) {
    return SessionState(
      status: status ?? this.status,
      session: clearSession ? null : (session ?? this.session),
      errorMessage: errorMessage,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
    );
  }
}

class SessionController extends StateNotifier<SessionState> {
  final Ref _ref;
  final RoutersRepository _routersRepo;

  SessionController(this._ref, this._routersRepo) : super(const SessionState());

  Future<bool> login({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
    bool acceptSelfSigned = true,
    bool useRest = false,
    bool rememberMe = true,
    String? label,
    int? existingConnectionId,
  }) async {
    // 1. Check lock
    if (state.isLocked) {
      state = state.copyWith(
        status: SessionStatus.error,
        errorMessage: 'تم تجاوز عدد المحاولات المسموح بها. الرجاء الانتظار ${state.remainingLockSeconds} ثانية.',
      );
      return false;
    }

    state = state.copyWith(status: SessionStatus.connecting, errorMessage: null);

    try {
      // 2. Connect via RouterOsAdapter
      final adapter = RouterOsAdapter.create(
        host: host,
        port: port,
        username: username,
        password: password,
        useSsl: useSsl,
        useRest: useRest,
      );

      final isConnected = await adapter.connect();
      if (!isConnected) {
        _handleFailedAttempt('تعذر تسجيل الدخول: تحقق من صحة اسم المستخدم وكلمة المرور وتفعيل المنفذ $port على الراوتر.');
        return false;
      }

      // 3. System resource check & version detection
      final res = await adapter.getSystemResource();
      final versionStr = res['version']?.toString() ?? '6.0';
      final boardName = res['board-name']?.toString() ?? 'MikroTik Router';
      final cpu = res['cpu']?.toString() ?? 'MIPS';

      // Parse major version (6 or 7)
      int majorVer = 6;
      final verMatch = RegExp(r'^(\d+)').firstMatch(versionStr);
      if (verMatch != null) {
        majorVer = int.tryParse(verMatch.group(1)!) ?? 6;
      }

      // 4. Derive user group and role
      UserRole userRole = UserRole.admin;
      String userGroupName = 'full';

      try {
        final users = await adapter.executeSentence(['/user/print', '?name=$username']);
        if (users.isSuccess && users.data.isNotEmpty) {
          userGroupName = users.data.first['group'] ?? 'full';
        }

        final groups = await adapter.executeSentence(['/user/group/print', '?name=$userGroupName']);
        if (groups.isSuccess && groups.data.isNotEmpty) {
          final policy = groups.data.first['policy'] ?? '';
          if (policy.contains('policy') || userGroupName == 'full') {
            userRole = UserRole.admin;
          } else if (policy.contains('write') || userGroupName == 'write') {
            userRole = UserRole.engineer;
          } else {
            userRole = UserRole.reseller;
          }
        }
      } catch (_) {
        // Fallback to group name if policies cannot be queried
        if (userGroupName == 'full') {
          userRole = UserRole.admin;
        } else if (userGroupName == 'write') {
          userRole = UserRole.engineer;
        } else {
          userRole = UserRole.reseller;
        }
      }

      // 5. Save or update connection in local database if rememberMe is enabled
      int connectionId = existingConnectionId ?? 0;
      if (existingConnectionId != null) {
        await _routersRepo.updateRouter(
          id: existingConnectionId,
          name: label ?? 'راوتر ($host)',
          ipAddress: host,
          apiPort: port,
          username: username,
          password: password,
          useSsl: useSsl,
          useRestApi: useRest,
        );
        await _routersRepo.setActiveRouter(existingConnectionId);
        connectionId = existingConnectionId;
      } else if (rememberMe) {
        final id = await _routersRepo.addRouter(
          name: (label != null && label.trim().isNotEmpty) ? label.trim() : 'راوتر ($host)',
          ipAddress: host,
          apiPort: port,
          username: username,
          password: password,
          useSsl: useSsl,
          useRestApi: useRest,
        );
        await _routersRepo.setActiveRouter(id);
        connectionId = id;
      } else {
        await SecureStorageService.saveRouterPassword(0, password);
      }

      final session = RouterSession(
        connectionId: connectionId,
        host: host,
        port: port,
        username: username,
        useSsl: useSsl,
        majorVersion: majorVer,
        versionString: versionStr,
        boardName: boardName,
        cpu: cpu,
        userGroup: userGroupName,
        role: userRole,
        adapter: adapter,
      );

      state = SessionState(
        status: SessionStatus.authenticated,
        session: session,
        failedAttempts: 0,
        lockedUntil: null,
      );

      // Also sync active router in routersControllerProvider
      final allRouters = await _routersRepo.getAllRouters();
      final active = allRouters.where((r) => r.id == connectionId).firstOrNull ?? allRouters.firstOrNull;
      if (active != null) {
        _ref.read(routersControllerProvider.notifier).selectActiveRouter(active);
      }

      return true;
    } on RouterOsException catch (e) {
      _handleFailedAttempt(e.message);
      return false;
    } catch (e) {
      _handleFailedAttempt('حدث خطأ أثناء الاتصال بالراوتر: ${e.toString()}');
      return false;
    }
  }

  void _handleFailedAttempt(String message) {
    final newAttempts = state.failedAttempts + 1;
    DateTime? lock;
    String finalMsg = message;

    if (newAttempts >= 5) {
      lock = DateTime.now().add(const Duration(seconds: 30));
      finalMsg = '$message\n(تم تجاوز الحد الأقصى للمحاولات؛ تم إيقاف زر الدخول لمدة 30 ثانية).';
    }

    state = state.copyWith(
      status: SessionStatus.error,
      errorMessage: finalMsg,
      failedAttempts: newAttempts,
      lockedUntil: lock,
      clearSession: true,
    );
  }

  Future<void> logout() async {
    try {
      state.session?.adapter.disconnect();
    } catch (_) {}

    state = const SessionState(
      status: SessionStatus.unauthenticated,
      session: null,
      errorMessage: null,
    );
    _ref.read(routersControllerProvider.notifier).logout();
  }
}

final sessionControllerProvider = StateNotifierProvider<SessionController, SessionState>((ref) {
  final repo = ref.watch(routersRepositoryProvider);
  return SessionController(ref, repo);
});
