import '../../../core/network/routeros_adapter.dart';
import '../../../core/network/routeros_exceptions.dart';
import '../../../core/network/routeros_socket_client.dart';

/// Strictly separated User Manager v6 adapter (RouterOS v6.x tool user-manager).
class UserManagerV6Adapter {
  final RouterOsSocketClient client;

  UserManagerV6Adapter(this.client);

  static const _kUmQueryTimeout = Duration(seconds: 60);
  static const _kFastTimeout = Duration(seconds: 10);

  /// Verify if the user-manager package is installed and enabled
  Future<bool> verifyPackageEnabled() async {
    final res = await client.executeSentence(
      withProplist(
          ['/system/package/print', '?name=user-manager'], 'name,disabled'),
      commandTimeout: _kFastTimeout,
    );
    if (!res.isSuccess || res.data.isEmpty) return false;
    final disabled = res.data.first['disabled'] ?? 'true';
    return disabled == 'false' || disabled == 'no';
  }

  /// List all customers/owners (production v6 routers rarely use just 'admin')
  Future<List<String>> getCustomers() async {
    final res = await client.executeSentence(
      withProplist(['/tool/user-manager/customer/print'], 'login,permissions'),
      commandTimeout: _kFastTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب قائمة عملاء User Manager v6: ${res.errorMessage ?? ""}',
      );
    }
    return res.data
        .map((r) => r['login'] ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Get profiles with dynamic customer resolution and attached limitations
  Future<List<Map<String, dynamic>>> getProfiles({String? customer}) async {
    List<Map<String, dynamic>> profiles = [];

    // Attempt 1: Fetch with specified customer, or without owner filter if not specified
    final cmd = ['/tool/user-manager/profile/print'];
    if (customer != null && customer.isNotEmpty) {
      cmd.add('?owner=$customer');
    }
    const proplist = '.id,name,owner,validity,price,shared-users';
    final res = await client.executeSentence(
      withProplist(cmd, proplist),
      commandTimeout: _kUmQueryTimeout,
    );

    if (res.isSuccess && res.data.isNotEmpty) {
      profiles = List<Map<String, dynamic>>.from(res.data);
    } else if (res.isSuccess && (customer == null || customer.isEmpty)) {
      // If no customer specified and empty, try discovering customers
      try {
        final customers = await getCustomers();
        if (customers.isNotEmpty) {
          final firstCustomer = customers.contains('admin') ? 'admin' : customers.first;
          final fallbackRes = await client.executeSentence(
            withProplist(['/tool/user-manager/profile/print', '?owner=$firstCustomer'], proplist),
            commandTimeout: _kUmQueryTimeout,
          );
          if (fallbackRes.isSuccess) {
            profiles = List<Map<String, dynamic>>.from(fallbackRes.data);
          }
        }
      } catch (_) {}
    } else if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب بروفايلات User Manager v6: ${res.errorMessage ?? ""}',
      );
    }

    // Link limitations (rate-limit, uptime-limit, transfer-limit)
    try {
      final profLimRes = await client.executeSentence(
        withProplist(['/tool/user-manager/profile/profile-limitation/print'],
            '.id,profile,limitation'),
        commandTimeout: _kFastTimeout,
      );
      final limRes = await client.executeSentence(
        withProplist(['/tool/user-manager/profile/limitation/print'],
            '.id,name,rate-limit-rx,rate-limit-tx,uptime-limit,download-limit,upload-limit,transfer-limit'),
        commandTimeout: _kFastTimeout,
      );

      if (profLimRes.isSuccess && limRes.isSuccess) {
        final Map<String, Map<String, dynamic>> limMap = {};
        for (final l in limRes.data) {
          final name = l['name']?.toString() ?? '';
          if (name.isNotEmpty) limMap[name] = l;
        }

        final Map<String, String> profToLim = {};
        for (final pl in profLimRes.data) {
          final p = pl['profile']?.toString() ?? '';
          final l = pl['limitation']?.toString() ?? '';
          if (p.isNotEmpty && l.isNotEmpty) {
            profToLim[p] = l;
          }
        }

        for (int i = 0; i < profiles.length; i++) {
          final pName = profiles[i]['name']?.toString() ?? '';
          final limName = profToLim[pName];
          if (limName != null && limMap.containsKey(limName)) {
            final lim = limMap[limName]!;
            final rx = lim['rate-limit-rx']?.toString();
            final tx = lim['rate-limit-tx']?.toString();
            String? rateLimit;
            if (rx != null && tx != null && rx.isNotEmpty && tx.isNotEmpty) {
              rateLimit = '$rx/$tx';
            }
            profiles[i] = {
              ...profiles[i],
              if (rateLimit != null) 'rate-limit': rateLimit,
              if (lim['uptime-limit'] != null)
                'uptime-limit': lim['uptime-limit'],
              if (lim['transfer-limit'] != null)
                'transfer-limit': lim['transfer-limit'],
            };
          }
        }
      }
    } catch (_) {
      // Non-fatal if limitations query is unsupported or restricted
    }

    return profiles;
  }

  /// Get all users with minimal proplist and normalization of username -> name
  Future<List<Map<String, dynamic>>> getUsers({String? customer}) async {
    final cmd = ['/tool/user-manager/user/print'];
    if (customer != null && customer.isNotEmpty) {
      cmd.add('?customer=$customer');
    }
    const proplist =
        '.id,username,customer,actual-profile,uptime-used,download-used,upload-used,active-sessions,shared-users,disabled,comment,caller-id';
    final res = await client.executeSentence(
      withProplist(cmd, proplist),
      commandTimeout: _kUmQueryTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب بطاقات User Manager v6: ${res.errorMessage ?? ""}',
      );
    }
    return res.data.map((row) {
      final username = row['username'] ?? row['name'] ?? '';
      return {
        ...row,
        'name': username,
        'uptime-used': row['uptime-used'] ?? '0s',
        'download-used': row['download-used'] ?? '0',
        'upload-used': row['upload-used'] ?? '0',
        'active-sessions': row['active-sessions'] ?? '0',
        'disabled': row['disabled'] ?? 'false',
      };
    }).toList();
  }

  /// Fetch active or all sessions
  Future<List<Map<String, dynamic>>> getSessions(
      {bool activeOnly = false}) async {
    final cmd = ['/tool/user-manager/session/print'];
    if (activeOnly) {
      cmd.add('?active=true');
    }
    const proplist =
        'user,customer,from-time,till-time,uptime,download,upload,active,terminate-cause,calling-station-id,user-ip';
    final res = await client.executeSentence(
      withProplist(cmd, proplist),
      commandTimeout: _kUmQueryTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب جلسات User Manager v6: ${res.errorMessage ?? ""}',
      );
    }
    return res.data;
  }

  /// Add a user card and activate their profile (strictly 2 steps)
  Future<bool> addUser({
    required String username,
    required String password,
    String? profile,
    String customer = 'admin',
    String? comment,
  }) async {
    final addCmd = [
      '/tool/user-manager/user/add',
      '=username=$username',
      '=password=$password',
      '=customer=$customer',
      if (comment != null && comment.isNotEmpty) '=comment=$comment',
    ];
    final res = await client.executeSentence(addCmd);
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'فشل إنشاء المشترك في User Manager v6: ${res.errorMessage ?? ""}',
      );
    }

    if (profile != null && profile.isNotEmpty) {
      final activateRes = await client.executeSentence([
        '/tool/user-manager/user/create-and-activate-profile',
        '=user=$username',
        '=customer=$customer',
        '=profile=$profile',
      ]);
      if (!activateRes.isSuccess) {
        throw RouterOsProtocolException(
          'تم إنشاء المشترك ولكن فشل تفعيل البروفايل ($profile): ${activateRes.errorMessage ?? ""}',
        );
      }
    }
    return true;
  }

  /// Remove user by RouterOS internal .id
  Future<bool> removeUser(String id) async {
    final res = await client.executeSentence([
      '/tool/user-manager/user/remove',
      '=.id=$id',
    ]);
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'فشل حذف المشترك v6: ${res.errorMessage ?? ""}',
      );
    }
    return true;
  }

  /// Kick session by RouterOS internal .id
  Future<bool> kickSession(String id) async {
    final res = await client.executeSentence([
      '/tool/user-manager/session/remove',
      '=.id=$id',
    ]);
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'فشل إنهاء الجلسة v6: ${res.errorMessage ?? ""}',
      );
    }
    return true;
  }
}
