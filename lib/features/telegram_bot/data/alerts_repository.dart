import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/routeros_adapter.dart';

class RogueDhcpAlert {
  final String serverIp;
  final String interface;
  final String macAddress;
  final bool isTrusted;
  final String status;

  const RogueDhcpAlert({
    required this.serverIp,
    required this.interface,
    this.macAddress = '',
    required this.isTrusted,
    required this.status,
  });
}

class AlertsRepository {
  final AppDatabase _db;

  AlertsRepository(this._db);

  // =========================================================================
  // Trusted DHCP Servers Management & Rogue Detection
  // =========================================================================

  Future<List<TrustedDhcpServersTableData>> getTrustedDhcpServers(int connectionId) async {
    return await (_db.select(_db.trustedDhcpServersTable)
          ..where((t) => t.connectionId.equals(connectionId)))
        .get();
  }

  Future<int> addTrustedDhcpServer({
    required int connectionId,
    required String serverIp,
    required String interface,
  }) async {
    return await _db.into(_db.trustedDhcpServersTable).insert(
      TrustedDhcpServersTableCompanion.insert(
        connectionId: connectionId,
        serverIp: serverIp,
        interface: interface,
      ),
    );
  }

  Future<int> removeTrustedDhcpServer(int id) async {
    return await (_db.delete(_db.trustedDhcpServersTable)..where((t) => t.id.equals(id))).go();
  }

  /// Scans RouterOS for rogue DHCP servers via `/ip/dhcp-server/alert/print` and active leases
  Future<List<RogueDhcpAlert>> scanForRogueDhcp({
    required int connectionId,
    required RouterOsAdapter adapter,
  }) async {
    final trustedList = await getTrustedDhcpServers(connectionId);
    final Set<String> trustedIps = trustedList.map((t) => t.serverIp).toSet();

    final List<RogueDhcpAlert> results = [];

    try {
      // 1. Query RouterOS DHCP Alert list
      final alertRes = await adapter.executeSentence(['/ip/dhcp-server/alert/print']);
      for (final row in alertRes.data) {
        final serverIp = row['unknown-server'] ?? row['server-address'] ?? '';
        final iface = row['interface'] ?? '';
        final valid = row['valid-server'] ?? '';

        if (serverIp.isNotEmpty) {
          final isTrusted = trustedIps.contains(serverIp) || valid.contains(serverIp);
          results.add(
            RogueDhcpAlert(
              serverIp: serverIp,
              interface: iface,
              isTrusted: isTrusted,
              status: isTrusted ? 'trusted' : 'rogue',
            ),
          );
        }
      }
    } catch (_) {}

    // If any rogue server detected, log event in alert_events
    for (final item in results) {
      if (!item.isTrusted) {
        await recordAlertEvent(
          connectionId: connectionId,
          ruleId: 0,
          status: 'confirmed',
          details: 'خادم DHCP دخيل غير مصرح به على IP: ${item.serverIp} الواجهة: ${item.interface}',
        );
      }
    }

    return results;
  }

  // =========================================================================
  // Quiet Hours (ساعات الهدوء)
  // =========================================================================

  Future<QuietHoursTableData?> getQuietHours(int connectionId) async {
    return await (_db.select(_db.quietHoursTable)
          ..where((t) => t.connectionId.equals(connectionId)))
        .getSingleOrNull();
  }

  Future<void> setQuietHours({
    required int connectionId,
    required int startMinute,
    required int endMinute,
    String days = '1,2,3,4,5,6,7',
    DateTime? muteUntil,
  }) async {
    final existing = await getQuietHours(connectionId);
    if (existing != null) {
      await (_db.update(_db.quietHoursTable)..where((t) => t.id.equals(existing.id))).write(
        QuietHoursTableCompanion(
          startMinute: Value(startMinute),
          endMinute: Value(endMinute),
          days: Value(days),
          muteUntil: Value(muteUntil),
        ),
      );
    } else {
      await _db.into(_db.quietHoursTable).insert(
        QuietHoursTableCompanion.insert(
          connectionId: connectionId,
          startMinute: startMinute,
          endMinute: endMinute,
          days: Value(days),
          muteUntil: Value(muteUntil),
        ),
      );
    }
  }

  bool isQuietHoursActive(QuietHoursTableData? quietHours, DateTime now) {
    if (quietHours == null) return false;

    // Check muteUntil override
    if (quietHours.muteUntil != null && now.isBefore(quietHours.muteUntil!)) {
      return true;
    }

    final currentDay = now.weekday.toString();
    final allowedDays = quietHours.days.split(',').map((s) => s.trim()).toSet();
    if (!allowedDays.contains(currentDay)) {
      return false;
    }

    final currentMinute = now.hour * 60 + now.minute;
    final start = quietHours.startMinute;
    final end = quietHours.endMinute;

    if (start <= end) {
      return currentMinute >= start && currentMinute <= end;
    } else {
      // Overnight (e.g. 23:00 to 07:00)
      return currentMinute >= start || currentMinute <= end;
    }
  }

  // =========================================================================
  // Alert Events Log
  // =========================================================================

  Future<int> recordAlertEvent({
    required int connectionId,
    required int ruleId,
    required String status,
    String? details,
    DateTime? at,
  }) async {
    return await _db.into(_db.alertEventsTable).insert(
      AlertEventsTableCompanion.insert(
        connectionId: connectionId,
        ruleId: ruleId,
        status: status,
        details: Value(details),
        at: Value(at ?? DateTime.now()),
      ),
    );
  }

  Future<List<AlertEventsTableData>> getAlertEvents(int connectionId) async {
    return await (_db.select(_db.alertEventsTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm(expression: t.at, mode: OrderingMode.desc)])
          ..limit(50))
        .get();
  }

  // =========================================================================
  // Netwatch Router Script Generator
  // =========================================================================

  String generateNetwatchScript({
    required String apName,
    required String apIp,
    required String botToken,
    required String chatId,
    int intervalSeconds = 30,
    int timeoutMs = 2000,
  }) {
    final sanitizedName = apName.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    final upText = 'AP $sanitizedName ($apIp) is UP';
    final downText = 'ALERT: AP $sanitizedName ($apIp) is DOWN!';

    return '''
# ================================================================
# MikroManager Pro - RouterOS Netwatch Telegram Alert
# AP: $apName ($apIp)
# ================================================================
/tool netwatch add host=$apIp interval=${intervalSeconds}s timeout=${timeoutMs}ms \\
  comment="MMPro_Netwatch_$sanitizedName" \\
  up-script="/tool fetch url=\\"https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatId&text=$upText\\" keep-result=no" \\
  down-script="/tool fetch url=\\"https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatId&text=$downText\\" keep-result=no"
''';
  }
}
