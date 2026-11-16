import '../../../core/network/routeros_adapter.dart';
import '../../../core/utils/audit_logger.dart';

class HotspotRepository {
  final AuditLogger _auditLogger;

  HotspotRepository(this._auditLogger);

  Future<List<Map<String, dynamic>>> getActiveUsers(RouterOsAdapter adapter) async {
    return await adapter.getHotspotActive();
  }

  Future<List<Map<String, dynamic>>> getUsers(RouterOsAdapter adapter) async {
    return await adapter.getHotspotUsers();
  }

  Future<List<Map<String, dynamic>>> getProfiles(RouterOsAdapter adapter) async {
    return await adapter.getHotspotProfiles();
  }

  Future<bool> addUser({
    required RouterOsAdapter adapter,
    required String name,
    required String password,
    required String profile,
    String? limitUptime,
    String? limitBytesTotal,
    String? comment,
  }) async {
    final success = await adapter.addHotspotUser(
      name: name,
      password: password,
      profile: profile,
      limitUptime: limitUptime,
      limitBytesTotal: limitBytesTotal,
      comment: comment,
    );

    if (success) {
      await _auditLogger.log(
        action: 'add_user',
        entityType: 'hotspot_user',
        entityId: name,
        description: 'إضافة مستخدم هوتس بوت جديد: $name (بروفايل: $profile)',
      );
    }

    return success;
  }

  Future<bool> removeUser({
    required RouterOsAdapter adapter,
    required String id,
    required String username,
  }) async {
    final success = await adapter.removeHotspotUser(id);
    if (success) {
      await _auditLogger.log(
        action: 'delete',
        entityType: 'hotspot_user',
        entityId: id,
        description: 'حذف مستخدم هوتس بوت: $username',
      );
    }
    return success;
  }

  Future<bool> kickUser({
    required RouterOsAdapter adapter,
    required String id,
    required String username,
  }) async {
    final success = await adapter.kickHotspotActive(id);
    if (success) {
      await _auditLogger.log(
        action: 'kick',
        entityType: 'hotspot_active',
        entityId: id,
        description: 'قطع اتصال المشترك (Kick): $username',
      );
    }
    return success;
  }
}
