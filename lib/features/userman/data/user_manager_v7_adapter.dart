import '../../../core/network/routeros_adapter.dart';
import '../../../core/network/routeros_exceptions.dart';
import '../../../core/network/routeros_socket_client.dart';

/// Strictly separated User Manager v7 adapter (RouterOS v7.x /user-manager).
class UserManagerV7Adapter {
  final RouterOsSocketClient client;

  UserManagerV7Adapter(this.client);

  static const _kUmQueryTimeout = Duration(seconds: 60);
  static const _kFastTimeout = Duration(seconds: 10);

  /// Verify if User Manager v7 is enabled and configured to use profiles
  Future<Map<String, bool>> verifyUmEnabled() async {
    final res = await client.executeSentence(
      withProplist(['/user-manager/print'], 'enabled,use-profiles'),
      commandTimeout: _kFastTimeout,
    );
    if (!res.isSuccess || res.data.isEmpty) {
      return {'enabled': false, 'useProfiles': false};
    }
    final first = res.data.first;
    final enabled = first['enabled'] == 'true' || first['enabled'] == 'yes';
    final useProfiles =
        first['use-profiles'] == 'true' || first['use-profiles'] == 'yes';
    return {'enabled': enabled, 'useProfiles': useProfiles};
  }

  /// Get profiles with minimal proplist
  Future<List<Map<String, dynamic>>> getProfiles() async {
    const proplist =
        '.id,name,name-for-users,price,validity,starts-when,override-shared-users';
    final res = await client.executeSentence(
      withProplist(['/user-manager/profile/print'], proplist),
      commandTimeout: _kUmQueryTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب بروفايلات User Manager v7: ${res.errorMessage ?? ""}',
      );
    }
    return res.data;
  }

  /// Get users with minimal proplist; gracefully handles RouterOS 7.18+ !empty
  Future<List<Map<String, dynamic>>> getUsers() async {
    const proplist =
        '.id,name,password,group,shared-users,caller-id,disabled,comment';
    final res = await client.executeSentence(
      withProplist(['/user-manager/user/print'], proplist),
      commandTimeout: _kUmQueryTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب مستخدمي User Manager v7: ${res.errorMessage ?? ""}',
      );
    }
    return res.data.map((row) {
      return {
        ...row,
        'disabled': row['disabled'] ?? 'false',
        'shared-users': row['shared-users'] ?? '1',
      };
    }).toList();
  }

  /// Get user-profile mappings in v7
  Future<List<Map<String, dynamic>>> getUserProfiles() async {
    const proplist = '.id,user,profile,state,end-time';
    final res = await client.executeSentence(
      withProplist(['/user-manager/user-profile/print'], proplist),
      commandTimeout: _kUmQueryTimeout,
    );
    if (!res.isSuccess) {
      return [];
    }
    return res.data;
  }

  /// Fetch active or all sessions
  Future<List<Map<String, dynamic>>> getSessions(
      {bool activeOnly = false}) async {
    final cmd = ['/user-manager/session/print'];
    if (activeOnly) {
      cmd.add('?active=true');
    }
    const proplist =
        'user,started,ended,active,uptime,download,upload,status,terminate-cause,calling-station-id,user-address';
    final res = await client.executeSentence(
      withProplist(cmd, proplist),
      commandTimeout: _kUmQueryTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب جلسات User Manager v7: ${res.errorMessage ?? ""}',
      );
    }
    return res.data;
  }

  /// Add a user card and bind profile in v7
  Future<bool> addUser({
    required String username,
    required String password,
    String? profile,
    String? comment,
  }) async {
    final addCmd = [
      '/user-manager/user/add',
      '=name=$username',
      '=password=$password',
      if (comment != null && comment.isNotEmpty) '=comment=$comment',
    ];
    final res = await client.executeSentence(addCmd);
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'فشل إنشاء المشترك في User Manager v7: ${res.errorMessage ?? ""}',
      );
    }

    if (profile != null && profile.isNotEmpty) {
      final profRes = await client.executeSentence([
        '/user-manager/user-profile/add',
        '=user=$username',
        '=profile=$profile',
      ]);
      if (!profRes.isSuccess) {
        throw RouterOsProtocolException(
          'تم إنشاء المشترك ولكن فشل ربط البروفايل ($profile): ${profRes.errorMessage ?? ""}',
        );
      }
    }
    return true;
  }

  /// Monitor user with mandatory =once= flag to prevent hanging
  Future<Map<String, dynamic>?> monitorUser(String username) async {
    final res = await client.executeSentence(
      ['/user-manager/user/monitor', '=user=$username', '=once='],
      commandTimeout: _kFastTimeout,
    );
    if (res.isSuccess && res.data.isNotEmpty) {
      return res.data.first;
    }
    return null;
  }

  /// Remove user
  Future<bool> removeUser(String id) async {
    final res = await client.executeSentence([
      '/user-manager/user/remove',
      '=.id=$id',
    ]);
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'فشل حذف المشترك v7: ${res.errorMessage ?? ""}',
      );
    }
    return true;
  }

  /// Kick session
  Future<bool> kickSession(String id) async {
    final res = await client.executeSentence([
      '/user-manager/session/remove',
      '=.id=$id',
    ]);
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'فشل إنهاء الجلسة v7: ${res.errorMessage ?? ""}',
      );
    }
    return true;
  }
}
