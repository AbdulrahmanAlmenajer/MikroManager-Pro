import 'routeros_socket_client.dart';
import 'routeros_rest_client.dart';
import '../constants/api_constants.dart';

abstract class RouterOsAdapter {
  Future<bool> connect();
  Future<bool> testConnection();
  void disconnect();
  bool get isConnected;
  bool get isV7;
  Future<RouterOsResponse> executeSentence(List<String> words);

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
  Future<bool> addHotspotIpBinding({required String macAddress, required String type, String? toAddress, String? comment});
  Future<bool> removeHotspotIpBinding(String id);

  // User Manager Operations
  Future<List<Map<String, dynamic>>> getUserManagerUsers();
  Future<List<Map<String, dynamic>>> getUserManagerProfiles();
  Future<List<Map<String, dynamic>>> getUserManagerSessions();
  Future<bool> addUserManagerUser({
    required String username,
    required String password,
    String? profile,
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
  bool _isV7 = true;

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
    return await _client.connect();
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
  Future<RouterOsResponse> executeSentence(List<String> words) async {
    return await _client.executeSentence(words);
  }

  @override
  Future<Map<String, dynamic>> getSystemResource() async {
    final res = await _client.executeSentence(['/system/resource/print']);
    if (res.isSuccess && res.data.isNotEmpty) {
      return res.data.first;
    }
    return {};
  }

  @override
  Future<List<Map<String, dynamic>>> getInterfaces() async {
    final res = await _client.executeSentence(['/interface/print']);
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
    final res = await _client.executeSentence(['/ip/hotspot/user/profile/print']);
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
    if (toAddress != null && toAddress.isNotEmpty) cmd.add('=to-address=$toAddress');
    if (comment != null && comment.isNotEmpty) cmd.add('=comment=$comment');
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
    // Check v7 vs v6 path
    var res = await _client.executeSentence(['/user-manager/user/print']);
    if (!res.isSuccess) {
      res = await _client.executeSentence(['/tool/user-manager/user/print']);
    }
    return res.isSuccess ? res.data : [];
  }

  @override
  Future<List<Map<String, dynamic>>> getUserManagerProfiles() async {
    var res = await _client.executeSentence(['/user-manager/profile/print']);
    if (!res.isSuccess) {
      res = await _client.executeSentence(['/tool/user-manager/profile/print']);
    }
    return res.isSuccess ? res.data : [];
  }

  @override
  Future<List<Map<String, dynamic>>> getUserManagerSessions() async {
    var res = await _client.executeSentence(['/user-manager/session/print']);
    if (!res.isSuccess) {
      res = await _client.executeSentence(['/tool/user-manager/session/print']);
    }
    return res.isSuccess ? res.data : [];
  }

  @override
  Future<bool> addUserManagerUser({
    required String username,
    required String password,
    String? profile,
    String? comment,
  }) async {
    final List<String> command = [
      '/user-manager/user/add',
      '=name=$username',
      '=password=$password',
    ];
    if (comment != null && comment.isNotEmpty) {
      command.add('=comment=$comment');
    }
    var res = await _client.executeSentence(command);
    if (!res.isSuccess) {
      // Legacy tool user-manager
      final List<String> legacyCommand = [
        '/tool/user-manager/user/add',
        '=username=$username',
        '=password=$password',
      ];
      if (comment != null) legacyCommand.add('=comment=$comment');
      res = await _client.executeSentence(legacyCommand);
    }
    return res.isSuccess;
  }

  @override
  Future<bool> removeUserManagerUser(String id) async {
    var res = await _client.executeSentence([
      '/user-manager/user/remove',
      '=.id=$id',
    ]);
    if (!res.isSuccess) {
      res = await _client.executeSentence([
        '/tool/user-manager/user/remove',
        '=.id=$id',
      ]);
    }
    return res.isSuccess;
  }

  @override
  Future<bool> kickUserManagerSession(String id) async {
    var res = await _client.executeSentence([
      '/user-manager/session/remove',
      '=.id=$id',
    ]);
    return res.isSuccess;
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
  Future<RouterOsResponse> executeSentence(List<String> words) async {
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
    try {
      final res = await _client.post(ApiConstants.interfaceStatsPath, {
        'interface': interfaceName,
        'once': true,
      });
      if (res.statusCode == 200 && res.data is List && (res.data as List).isNotEmpty) {
        final first = (res.data as List).first as Map;
        final rx = int.tryParse(first['rx-bits-per-second']?.toString() ?? '0') ?? 0;
        final tx = int.tryParse(first['tx-bits-per-second']?.toString() ?? '0') ?? 0;
        return {'rx': rx, 'tx': tx};
      }
    } catch (_) {}
    return {'rx': 0, 'tx': 0};
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
  Future<List<Map<String, dynamic>>> getUserManagerSessions() async {
    return await _client.get('/rest/user-manager/session');
  }

  @override
  Future<bool> addUserManagerUser({
    required String username,
    required String password,
    String? profile,
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
    final res = await _client.delete('${ApiConstants.userManagerUsersPath}/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }

  @override
  Future<bool> kickUserManagerSession(String id) async {
    final res = await _client.delete('/rest/user-manager/session/$id');
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
