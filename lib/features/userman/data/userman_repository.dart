import '../../../core/network/routeros_adapter.dart';
import '../../../core/utils/audit_logger.dart';

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
