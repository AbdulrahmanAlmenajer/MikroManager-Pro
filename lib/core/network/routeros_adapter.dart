import 'routeros_socket_client.dart';
import 'routeros_rest_client.dart';
import 'routeros_exceptions.dart';
import '../constants/api_constants.dart';
import '../../features/userman/data/user_manager_v6_adapter.dart';
import '../../features/userman/data/user_manager_v7_adapter.dart';

// ---------------------------------------------------------------------------
// Timeout constants
// ---------------------------------------------------------------------------
/// Short timeout for login, /system/resource, and small single-row commands.
const _kLoginTimeout = Duration(seconds: 10);

/// Long timeout for large User Manager tables (1 000–20 000+ cards).
const _kUmTableTimeout = Duration(seconds: 60);

// ---------------------------------------------------------------------------
// .proplist helper
// ---------------------------------------------------------------------------
/// Appends `=.proplist=<fields>` to a print command list.
List<String> withProplist(List<String> cmd, String fields) =>
    [...cmd, '=.proplist=$fields'];

abstract class RouterOsAdapter {
  Future<bool> connect();
  Future<bool> testConnection();
  void disconnect();
  bool get isConnected;
  bool get isV7;
  Future<RouterOsResponse> executeSentence(
    List<String> words, {
    Duration? commandTimeout,
  });

  // System & Resource Monitoring
  Future<Map<String, dynamic>> getSystemResource();
  Future<List<Map<String, dynamic>>> getInterfaces();
  Future<Map<String, int>> getInterfaceTraffic(String interfaceName);

  // Hotspot Operations
  Future<List<Map<String, dynamic>>> getHotspotUsers();
  Future<List<Map<String, dynamic>>> getHotspotActive();
  Future<List<Map<String, dynamic>>> getHotspotProfiles();
  Future<bool> addHotspotUser({
    required String name,
    required String password,
    required String profile,
    String? limitUptime,
    String? limitBytesTotal,
    String? comment,
  });
  Future<bool> removeHotspotUser(String id);
  Future<bool> kickHotspotActive(String id);
  Future<List<Map<String, dynamic>>> getHotspotIpBindings();
  Future<bool> addHotspotIpBinding(
      {required String macAddress,
      required String type,
      String? toAddress,
      String? comment});
  Future<bool> removeHotspotIpBinding(String id);

  // User Manager Operations
  Future<List<Map<String, dynamic>>> getUserManagerUsers();
  Future<List<Map<String, dynamic>>> getUserManagerProfiles();

  /// Fetch sessions; pass [activeOnly]=true to query only active sessions.
  Future<List<Map<String, dynamic>>> getUserManagerSessions({
    bool activeOnly = false,
  });
  Future<List<String>> getUserManagerCustomers();
  Future<bool> addUserManagerUser({
    required String username,
    required String password,
    String? profile,
    String? customer,
    String? comment,
  });
  Future<bool> removeUserManagerUser(String id);
  Future<bool> kickUserManagerSession(String id);

  // Factory to create appropriate adapter
  static RouterOsAdapter create({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
    bool useRest = false,
  }) {
    if (useRest) {
      return RouterOsRestAdapter(
        host: host,
        port: port,
        username: username,
        password: password,
        useSsl: useSsl,
      );
    } else {
      return RouterOsBinaryAdapter(
        host: host,
        port: port,
        username: username,
        password: password,
        useSsl: useSsl,
      );
    }
  }
}

/// Binary API Adapter Implementation (ports 8728 / 8729)
class RouterOsBinaryAdapter implements RouterOsAdapter {
  final RouterOsSocketClient _client;

  /// True = RouterOS 7.x detected; False = RouterOS 6.x detected.
  /// Set to `null` until `connect()` has been called and version read.
  bool _isV7 = false;

  UserManagerV6Adapter get umV6 => UserManagerV6Adapter(_client);
  UserManagerV7Adapter get umV7 => UserManagerV7Adapter(_client);

  @override
  bool get isV7 => _isV7;
  set isV7(bool v) => _isV7 = v;

  RouterOsBinaryAdapter({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
  }) : _client = RouterOsSocketClient(
          host: host,
          port: port,
          username: username,
          password: password,
          useSsl: useSsl,
        );

  @override
  bool get isConnected => _client.isConnected;

  @override
  Future<bool> connect() async {
    final ok = await _client.connect();
    if (ok) {
      // Detect RouterOS major version from /system/resource
      try {
        final res = await _client.executeSentence(
          withProplist(['/system/resource/print'], 'version'),
          commandTimeout: _kLoginTimeout,
        );
        if (res.isSuccess && res.data.isNotEmpty) {
          final version = res.data.first['version'] ?? '';
          final major = int.tryParse(version.split('.').first) ?? 7;
          _isV7 = major >= 7;
        }
      } on RouterOsException {
        // If version probe fails, default to v6 (safer for UM paths)
        _isV7 = false;
      }
    }
    return ok;
  }

  @override
  Future<bool> testConnection() async {
    final connected = await _client.connect();
    if (connected) {
      _client.close();
      return true;
    }
    return false;
  }

  @override
  void disconnect() {
    _client.close();
  }

  @override
  Future<RouterOsResponse> executeSentence(
    List<String> words, {
    Duration? commandTimeout,
  }) async {
    return await _client.executeSentence(words, commandTimeout: commandTimeout);
  }

  @override
  Future<Map<String, dynamic>> getSystemResource() async {
    final res = await _client.executeSentence(
      withProplist([
        '/system/resource/print'
      ], 'version,uptime,cpu-load,free-memory,total-memory,free-hdd-space,total-hdd-space,board-name'),
      commandTimeout: _kLoginTimeout,
    );
    if (res.isSuccess && res.data.isNotEmpty) {
      return res.data.first;
    }
    return {};
  }

  @override
  Future<List<Map<String, dynamic>>> getInterfaces() async {
    final res = await _client.executeSentence(
      withProplist(['/interface/print'],
          '.id,name,type,running,disabled,comment,mac-address,rx-byte,tx-byte'),
    );
    return res.isSuccess ? res.data : [];
  }

  @override
  Future<Map<String, int>> getInterfaceTraffic(String interfaceName) async {
    final res = await _client.executeSentence([
      '/interface/monitor-traffic',
      '=interface=$interfaceName',
      '=once=',
    ]);
    if (res.isSuccess && res.data.isNotEmpty) {
      final first = res.data.first;
      final rx = int.tryParse(first['rx-bits-per-second'] ?? '0') ?? 0;
      final tx = int.tryParse(first['tx-bits-per-second'] ?? '0') ?? 0;
      return {'rx': rx, 'tx': tx};
    }
    return {'rx': 0, 'tx': 0};
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspotUsers() async {
    final res = await _client.executeSentence(['/ip/hotspot/user/print']);
    return res.isSuccess ? res.data : [];
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspotActive() async {
    final res = await _client.executeSentence(['/ip/hotspot/active/print']);
    return res.isSuccess ? res.data : [];
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspotProfiles() async {
    final res =
        await _client.executeSentence(['/ip/hotspot/user/profile/print']);
    return res.isSuccess ? res.data : [];
  }

  @override
  Future<bool> addHotspotUser({
    required String name,
    required String password,
    required String profile,
    String? limitUptime,
    String? limitBytesTotal,
    String? comment,
  }) async {
    final List<String> command = [
      '/ip/hotspot/user/add',
      '=name=$name',
      '=password=$password',
      '=profile=$profile',
    ];
    if (limitUptime != null && limitUptime.isNotEmpty) {
      command.add('=limit-uptime=$limitUptime');
    }
    if (limitBytesTotal != null && limitBytesTotal.isNotEmpty) {
      command.add('=limit-bytes-total=$limitBytesTotal');
    }
    if (comment != null && comment.isNotEmpty) {
      command.add('=comment=$comment');
    }

    final res = await _client.executeSentence(command);
    return res.isSuccess;
  }

  @override
  Future<bool> removeHotspotUser(String id) async {
    final res = await _client.executeSentence([
      '/ip/hotspot/user/remove',
      '=.id=$id',
    ]);
    return res.isSuccess;
  }

  @override
  Future<bool> kickHotspotActive(String id) async {
    final res = await _client.executeSentence([
      '/ip/hotspot/active/remove',
      '=.id=$id',
    ]);
    return res.isSuccess;
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspotIpBindings() async {
    final res = await _client.executeSentence(['/ip/hotspot/ip-binding/print']);
    return res.isSuccess ? res.data : [];
  }

  @override
  Future<bool> addHotspotIpBinding({
    required String macAddress,
    required String type,
    String? toAddress,
    String? comment,
  }) async {
    final List<String> cmd = [
      '/ip/hotspot/ip-binding/add',
      '=mac-address=$macAddress',
      '=type=$type',
    ];
    if (toAddress != null && toAddress.isNotEmpty) {
      cmd.add('=to-address=$toAddress');
    }
    if (comment != null && comment.isNotEmpty) {
      cmd.add('=comment=$comment');
    }
    final res = await _client.executeSentence(cmd);
    return res.isSuccess;
  }

  @override
  Future<bool> removeHotspotIpBinding(String id) async {
    final res = await _client.executeSentence([
      '/ip/hotspot/ip-binding/remove',
      '=.id=$id',
    ]);
    return res.isSuccess;
  }

  @override
  Future<List<Map<String, dynamic>>> getUserManagerUsers() async {
    // Minimal proplist: only fields the UI actually uses
    const v7Proplist =
        '.id,name,password,group,shared-users,caller-id,disabled,comment';
    const v6Proplist =
        '.id,username,customer,actual-profile,uptime-used,download-used,upload-used,active-sessions,shared-users,disabled,comment,caller-id';

    if (_isV7) {
      final res = await _client.executeSentence(
        withProplist(['/user-manager/user/print'], v7Proplist),
        commandTimeout: _kUmTableTimeout,
      );
      if (res.isSuccess) return res.data;
      // Fall through to v6 if v7 path trapped
    }

    // v6 path
    final res = await _client.executeSentence(
      withProplist(['/tool/user-manager/user/print'], v6Proplist),
      commandTimeout: _kUmTableTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب مستخدمي User Manager: ${res.errorMessage ?? "خطأ غير معروف"}',
      );
    }
    // Normalise v6 `username` → `name` so the UI reads one field
    return res.data.map((row) {
      if (!row.containsKey('name') && row.containsKey('username')) {
        return {...row, 'name': row['username']!};
      }
      return row;
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getUserManagerProfiles() async {
    const v7Proplist =
        '.id,name,name-for-users,price,validity,starts-when,override-shared-users';
    const v6Proplist = '.id,name,owner,validity,price,shared-users';

    if (_isV7) {
      final res = await _client.executeSentence(
        withProplist(['/user-manager/profile/print'], v7Proplist),
        commandTimeout: _kUmTableTimeout,
      );
      if (res.isSuccess) return res.data;
      throw RouterOsProtocolException(
        'تعذّر جلب بروفايلات User Manager v7: ${res.errorMessage ?? "تأكد من تفعيل حزمة user-manager وصلاحيات المستخدم"}',
      );
    }

    final res = await _client.executeSentence(
      withProplist(['/tool/user-manager/profile/print'], v6Proplist),
      commandTimeout: _kUmTableTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب بروفايلات User Manager v6: ${res.errorMessage ?? "تأكد من تثبيت وتفعيل حزمة user-manager"}',
      );
    }
    return res.data;
  }

  @override
  Future<List<Map<String, dynamic>>> getUserManagerSessions({
    bool activeOnly = false,
  }) async {
    const v7Proplist =
        'user,started,ended,active,uptime,download,upload,status,terminate-cause,calling-station-id,user-address';
    const v6Proplist =
        'user,customer,from-time,till-time,uptime,download,upload,active,terminate-cause,calling-station-id,user-ip';

    final filterWords = activeOnly ? ['?active=true'] : const <String>[];

    if (_isV7) {
      final res = await _client.executeSentence(
        withProplist(
            ['/user-manager/session/print', ...filterWords], v7Proplist),
        commandTimeout: _kUmTableTimeout,
      );
      if (res.isSuccess) return res.data;
    }

    final res = await _client.executeSentence(
      withProplist(
          ['/tool/user-manager/session/print', ...filterWords], v6Proplist),
      commandTimeout: _kUmTableTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب جلسات User Manager: ${res.errorMessage ?? "خطأ غير معروف"}',
      );
    }
    return res.data;
  }

  @override
  Future<List<String>> getUserManagerCustomers() async {
    // v6 only: /tool/user-manager/customer/print
    if (_isV7) return const ['admin']; // v7 has no separate customer concept
    final res = await _client.executeSentence(
      withProplist(['/tool/user-manager/customer/print'], 'login'),
      commandTimeout: _kLoginTimeout,
    );
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'تعذّر جلب قائمة العملاء: ${res.errorMessage ?? "خطأ غير معروف"}',
      );
    }
    return res.data
        .map((r) => r['login'] ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  @override
  Future<bool> addUserManagerUser({
    required String username,
    required String password,
    String? profile,
    String? customer,
    String? comment,
  }) async {
    if (_isV7) {
      // v7: /user-manager/user/add then /user-manager/user-profile/add
      final cmd = [
        '/user-manager/user/add',
        '=name=$username',
        '=password=$password',
        if (comment != null && comment.isNotEmpty) '=comment=$comment',
      ];
      final res = await _client.executeSentence(cmd);
      if (!res.isSuccess) {
        throw RouterOsProtocolException(
          'فشل إنشاء المستخدم (v7): ${res.errorMessage ?? ""}',
        );
      }
      if (profile != null && profile.isNotEmpty) {
        final profRes = await _client.executeSentence([
          '/user-manager/user-profile/add',
          '=user=$username',
          '=profile=$profile',
        ]);
        if (!profRes.isSuccess) {
          throw RouterOsProtocolException(
            'تم إنشاء المستخدم لكن فشل ربط البروفايل: ${profRes.errorMessage ?? ""}',
          );
        }
      }
      return true;
    } else {
      // v6: two-step — user/add then create-and-activate-profile
      final effectiveCustomer = customer ?? 'admin';
      final cmd = [
        '/tool/user-manager/user/add',
        '=username=$username',
        '=password=$password',
        '=customer=$effectiveCustomer',
        if (comment != null && comment.isNotEmpty) '=comment=$comment',
      ];
      final res = await _client.executeSentence(cmd);
      if (!res.isSuccess) {
        throw RouterOsProtocolException(
          'فشل إنشاء المستخدم (v6): ${res.errorMessage ?? ""}',
        );
      }
      if (profile != null && profile.isNotEmpty) {
        final activateRes = await _client.executeSentence([
          '/tool/user-manager/user/create-and-activate-profile',
          '=user=$username',
          '=customer=$effectiveCustomer',
          '=profile=$profile',
        ]);
        if (!activateRes.isSuccess) {
          throw RouterOsProtocolException(
            'تم إنشاء المستخدم لكن فشل تفعيل البروفايل: ${activateRes.errorMessage ?? ""}',
          );
        }
      }
      return true;
    }
  }

  @override
  Future<bool> removeUserManagerUser(String id) async {
    final path =
        _isV7 ? '/user-manager/user/remove' : '/tool/user-manager/user/remove';
    final res = await _client.executeSentence([path, '=.id=$id']);
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'فشل حذف المستخدم: ${res.errorMessage ?? ""}',
      );
    }
    return true;
  }

  @override
  Future<bool> kickUserManagerSession(String id) async {
    final path = _isV7
        ? '/user-manager/session/remove'
        : '/tool/user-manager/session/remove';
    final res = await _client.executeSentence([path, '=.id=$id']);
    if (!res.isSuccess) {
      throw RouterOsProtocolException(
        'فشل إنهاء الجلسة: ${res.errorMessage ?? ""}',
      );
    }
    return true;
  }
}

/// REST API Adapter Implementation (RouterOS v7+)
class RouterOsRestAdapter implements RouterOsAdapter {
  final RouterOsRestClient _client;
  bool _connected = false;

  RouterOsRestAdapter({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
  }) : _client = RouterOsRestClient(
          host: host,
          port: port,
          username: username,
          password: password,
          useSsl: useSsl,
        );

  @override
  bool get isConnected => _connected;

  @override
  bool get isV7 => true;

  @override
  Future<bool> connect() async {
    _connected = await _client.testConnection();
    return _connected;
  }

  @override
  Future<bool> testConnection() async {
    return await _client.testConnection();
  }

  @override
  void disconnect() {
    _connected = false;
  }

  @override
  Future<RouterOsResponse> executeSentence(
    List<String> words, {
    Duration? commandTimeout,
  }) async {
    return RouterOsResponse(isSuccess: true, data: []);
  }

  @override
  Future<Map<String, dynamic>> getSystemResource() async {
    final list = await _client.get(ApiConstants.systemResourcePath);
    return list.isNotEmpty ? list.first : {};
  }

  @override
  Future<List<Map<String, dynamic>>> getInterfaces() async {
    return await _client.get(ApiConstants.interfacesPath);
  }

  @override
  Future<Map<String, int>> getInterfaceTraffic(String interfaceName) async {
    final res = await _client.post(ApiConstants.interfaceStatsPath, {
      'interface': interfaceName,
      'once': true,
    });
    if (res.statusCode == 200 &&
        res.data is List &&
        (res.data as List).isNotEmpty) {
      final first = (res.data as List).first as Map;
      final rx =
          int.tryParse(first['rx-bits-per-second']?.toString() ?? '0') ?? 0;
      final tx =
          int.tryParse(first['tx-bits-per-second']?.toString() ?? '0') ?? 0;
      return {'rx': rx, 'tx': tx};
    }
    throw RouterOsProtocolException(
      'تعذّر جلب إحصائيات الواجهة "$interfaceName" عبر REST (رمز ${res.statusCode})',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspotUsers() async {
    return await _client.get(ApiConstants.hotspotUsersPath);
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspotActive() async {
    return await _client.get(ApiConstants.hotspotActivePath);
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspotProfiles() async {
    return await _client.get(ApiConstants.hotspotProfilesPath);
  }

  @override
  Future<bool> addHotspotUser({
    required String name,
    required String password,
    required String profile,
    String? limitUptime,
    String? limitBytesTotal,
    String? comment,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'password': password,
      'profile': profile,
    };
    if (limitUptime != null) body['limit-uptime'] = limitUptime;
    if (limitBytesTotal != null) body['limit-bytes-total'] = limitBytesTotal;
    if (comment != null) body['comment'] = comment;

    final res = await _client.put(ApiConstants.hotspotUsersPath, body);
    return res.statusCode == 200 || res.statusCode == 201;
  }

  @override
  Future<bool> removeHotspotUser(String id) async {
    final res = await _client.delete('${ApiConstants.hotspotUsersPath}/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }

  @override
  Future<bool> kickHotspotActive(String id) async {
    final res = await _client.delete('${ApiConstants.hotspotActivePath}/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspotIpBindings() async {
    return await _client.get('/rest/ip/hotspot/ip-binding');
  }

  @override
  Future<bool> addHotspotIpBinding({
    required String macAddress,
    required String type,
    String? toAddress,
    String? comment,
  }) async {
    final Map<String, dynamic> body = {
      'mac-address': macAddress,
      'type': type,
    };
    if (toAddress != null) body['to-address'] = toAddress;
    if (comment != null) body['comment'] = comment;
    final res = await _client.put('/rest/ip/hotspot/ip-binding', body);
    return res.statusCode == 200 || res.statusCode == 201;
  }

  @override
  Future<bool> removeHotspotIpBinding(String id) async {
    final res = await _client.delete('/rest/ip/hotspot/ip-binding/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }

  @override
  Future<List<Map<String, dynamic>>> getUserManagerUsers() async {
    return await _client.get(ApiConstants.userManagerUsersPath);
  }

  @override
  Future<List<Map<String, dynamic>>> getUserManagerProfiles() async {
    return await _client.get(ApiConstants.userManagerProfilesPath);
  }

  @override
  Future<List<Map<String, dynamic>>> getUserManagerSessions({
    bool activeOnly = false,
  }) async {
    final path = activeOnly
        ? '/rest/user-manager/session?active=true'
        : '/rest/user-manager/session';
    return await _client.get(path);
  }

  @override
  Future<List<String>> getUserManagerCustomers() async {
    // REST adapter is v7-only; no customer concept
    return const ['admin'];
  }

  @override
  Future<bool> addUserManagerUser({
    required String username,
    required String password,
    String? profile,
    String? customer,
    String? comment,
  }) async {
    final Map<String, dynamic> body = {
      'name': username,
      'password': password,
    };
    if (comment != null) body['comment'] = comment;
    final res = await _client.put(ApiConstants.userManagerUsersPath, body);
    return res.statusCode == 200 || res.statusCode == 201;
  }

  @override
  Future<bool> removeUserManagerUser(String id) async {
    final res =
        await _client.delete('${ApiConstants.userManagerUsersPath}/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }

  @override
  Future<bool> kickUserManagerSession(String id) async {
    final res = await _client.delete('/rest/user-manager/session/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
