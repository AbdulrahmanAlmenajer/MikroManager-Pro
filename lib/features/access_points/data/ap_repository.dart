import 'dart:async';
import 'dart:io';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/routeros_adapter.dart';
import '../../../core/security/secure_storage_service.dart';

class DiscoveredNeighbor {
  final String identity;
  final String ip;
  final String macAddress;
  final String vendor;
  final String interface;
  final String? platform;

  const DiscoveredNeighbor({
    required this.identity,
    required this.ip,
    required this.macAddress,
    required this.vendor,
    required this.interface,
    this.platform,
  });
}

class ApRepository {
  final AppDatabase _db;

  ApRepository(this._db);

  // =========================================================================
  // Drift Database Operations
  // =========================================================================

  Future<List<ApDevicesTableData>> getAllAps(int connectionId) async {
    return await (_db.select(_db.apDevicesTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  Future<int> addAp({
    required int connectionId,
    required String name,
    required String ip,
    String vendor = 'MikroTik',
    String? username,
    String? password,
  }) async {
    final id = await _db.into(_db.apDevicesTable).insert(
      ApDevicesTableCompanion.insert(
        connectionId: connectionId,
        name: name,
        ip: ip,
        vendor: Value(vendor),
        accessState: const Value('unknown'),
      ),
    );

    // Save credentials in flutter_secure_storage
    if ((username != null && username.isNotEmpty) || (password != null && password.isNotEmpty)) {
      try {
        await SecureStorageService.saveApCredentials(id, username: username, password: password);
      } catch (_) {}
    }

    return id;
  }

  Future<bool> updateAp({
    required int id,
    required String name,
    required String ip,
    required String vendor,
    String? username,
    String? password,
  }) async {
    final success = await (_db.update(_db.apDevicesTable)..where((t) => t.id.equals(id))).write(
      ApDevicesTableCompanion(
        name: Value(name),
        ip: Value(ip),
        vendor: Value(vendor),
      ),
    );

    if (username != null || password != null) {
      try {
        await SecureStorageService.saveApCredentials(id, username: username, password: password);
      } catch (_) {}
    }

    return success > 0;
  }

  Future<int> deleteAp(int id) async {
    try {
      await SecureStorageService.deleteApCredentials(id);
    } catch (_) {}
    return await (_db.delete(_db.apDevicesTable)..where((t) => t.id.equals(id))).go();
  }

  Future<Map<String, String?>> getApCredentials(int id) async {
    try {
      return await SecureStorageService.getApCredentials(id);
    } catch (_) {
      return {'username': null, 'password': null};
    }
  }

  // =========================================================================
  // Discovery via RouterOS MNDP / CDP / LLDP (/ip/neighbor/print)
  // =========================================================================

  Future<List<DiscoveredNeighbor>> discoverNeighbors(RouterOsAdapter adapter) async {
    final response = await adapter.executeSentence(['/ip/neighbor/print']);
    final List<DiscoveredNeighbor> results = [];

    for (final row in response.data) {
      final ip = row['address'] ?? row['address4'] ?? row['ipv4-address'] ?? '';
      if (ip.isEmpty || ip == '0.0.0.0') continue;

      final identity = row['identity'] ?? row['board'] ?? row['system-description'] ?? 'AP-$ip';
      final mac = row['mac-address'] ?? '';
      final iface = row['interface'] ?? '';
      final platform = row['platform'] ?? row['board'] ?? '';

      // Infer vendor
      final vendor = _inferVendor(identity, platform, mac);

      results.add(
        DiscoveredNeighbor(
          identity: identity,
          ip: ip,
          macAddress: mac,
          vendor: vendor,
          interface: iface,
          platform: platform.isNotEmpty ? platform : null,
        ),
      );
    }

    return results;
  }

  String _inferVendor(String identity, String platform, String mac) {
    final text = '$identity $platform'.toLowerCase();
    if (text.contains('ubiquiti') ||
        text.contains('nanostation') ||
        text.contains('litebeam') ||
        text.contains('powerbeam') ||
        text.contains('rocket') ||
        text.contains('airmax') ||
        text.contains('unifi')) {
      return 'Ubiquiti';
    }
    if (text.contains('tp-link') || text.contains('pharos') || text.contains('cpe')) {
      return 'TP-Link';
    }
    if (text.contains('cambium') || text.contains('epmp')) {
      return 'Cambium';
    }
    if (text.contains('mikrotik') || text.contains('routerboard') || text.contains('rb')) {
      return 'MikroTik';
    }
    return 'MikroTik';
  }

  // =========================================================================
  // Health & Reachability Check (TCP Port Probing)
  // =========================================================================

  Future<String> probeAccessState(String ip) async {
    // Attempt HTTP port 80
    try {
      final s80 = await Socket.connect(ip, 80, timeout: const Duration(milliseconds: 1500));
      s80.destroy();
      return 'ok';
    } catch (_) {}

    // Attempt HTTPS port 443
    try {
      final s443 = await Socket.connect(ip, 443, timeout: const Duration(milliseconds: 1500));
      s443.destroy();
      return 'ok';
    } catch (_) {}

    // Attempt RouterOS API port 8728
    try {
      final s8728 = await Socket.connect(ip, 8728, timeout: const Duration(milliseconds: 1500));
      s8728.destroy();
      return 'ok';
    } catch (_) {}

    return 'unreachable';
  }

  Future<void> refreshApState(int apId, String ip) async {
    final state = await probeAccessState(ip);
    await (_db.update(_db.apDevicesTable)..where((t) => t.id.equals(apId))).write(
      ApDevicesTableCompanion(
        accessState: Value(state),
        lastCheckAt: Value(DateTime.now()),
      ),
    );
  }
}
