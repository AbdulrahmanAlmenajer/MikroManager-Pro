import '../../../core/network/routeros_adapter.dart';
import '../../../core/utils/audit_logger.dart';
import '../domain/um_profile_model.dart';

class UsermanRepository {
  final AuditLogger _auditLogger;

  UsermanRepository(this._auditLogger);

  Future<List<Map<String, dynamic>>> getUsers(RouterOsAdapter adapter) async {
    return await adapter.getUserManagerUsers();
  }

  Future<List<Map<String, dynamic>>> getProfiles(
      RouterOsAdapter adapter) async {
    return await adapter.getUserManagerProfiles();
  }

  Future<List<Map<String, dynamic>>> getSessions(
      RouterOsAdapter adapter) async {
    return await adapter.getUserManagerSessions();
  }

  /// Get rich parsed profiles with user counts and prices
  Future<List<UmProfileModel>> getParsedProfiles(
    RouterOsAdapter adapter, {
    Map<String, double> localPrices = const {},
  }) async {
    final rawProfiles = await adapter.getUserManagerProfiles();
    final rawUsers = await adapter.getUserManagerUsers();
    final rawSessions = await adapter.getUserManagerSessions(activeOnly: true);

    // Count users per profile
    final Map<String, int> usersCountMap = {};
    for (final u in rawUsers) {
      final prof = u['actual-profile']?.toString() ??
          u['profile']?.toString() ??
          u['group']?.toString() ??
          'default';
      usersCountMap[prof] = (usersCountMap[prof] ?? 0) + 1;
    }

    // Count active sessions per profile (by matching user to profile)
    final Map<String, String> userToProfile = {};
    for (final u in rawUsers) {
      final name = u['username']?.toString() ?? u['name']?.toString() ?? '';
      final prof = u['actual-profile']?.toString() ??
          u['profile']?.toString() ??
          u['group']?.toString() ??
          'default';
      if (name.isNotEmpty) {
        userToProfile[name] = prof;
      }
    }

    final Map<String, int> activeSessionsMap = {};
    for (final s in rawSessions) {
      final user = s['user']?.toString() ?? '';
      final prof = userToProfile[user] ?? 'default';
      activeSessionsMap[prof] = (activeSessionsMap[prof] ?? 0) + 1;
    }

    return rawProfiles.map((map) {
      final name = map['name']?.toString() ?? '';
      final fallbackPrice = localPrices[name];
      return UmProfileModel.fromMap(
        map,
        isV7: adapter.isV7,
        usersCount: usersCountMap[name] ?? 0,
        activeSessionsCount: activeSessionsMap[name] ?? 0,
        fallbackPrice: fallbackPrice,
      );
    }).toList();
  }

  Future<bool> addUser({
    required RouterOsAdapter adapter,
    required String username,
    required String password,
    String? profile,
    String? customer,
    String? comment,
  }) async {
    final success = await adapter.addUserManagerUser(
      username: username,
      password: password,
      profile: profile,
      customer: customer,
      comment: comment,
    );

    if (success) {
      await _auditLogger.log(
        action: 'add_user',
        entityType: 'userman_user',
        entityId: username,
        description: 'إضافة مستخدم User Manager: $username (بروفايل: $profile)',
      );
    }

    return success;
  }

  Future<bool> removeUser({
    required RouterOsAdapter adapter,
    required String id,
    required String username,
  }) async {
    final success = await adapter.removeUserManagerUser(id);
    if (success) {
      await _auditLogger.log(
        action: 'delete',
        entityType: 'userman_user',
        entityId: id,
        description: 'حذف مستخدم User Manager: $username',
      );
    }
    return success;
  }

  Future<bool> kickSession({
    required RouterOsAdapter adapter,
    required String id,
    required String username,
  }) async {
    final success = await adapter.kickUserManagerSession(id);
    if (success) {
      await _auditLogger.log(
        action: 'kick',
        entityType: 'userman_session',
        entityId: id,
        description: 'إنهاء جلسة User Manager للمشترك: $username',
      );
    }
    return success;
  }
}
