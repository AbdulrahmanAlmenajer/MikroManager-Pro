import '../../../core/network/routeros_adapter.dart';
import '../../../core/utils/audit_logger.dart';

enum SubscriberType {
  hotspot,
  userMan,
  pppoe,
}

class SubscriberModel {
  final String id;
  final String username;
  final String? password;
  final String profile;
  final SubscriberType type;
  final bool isDisabled;
  final bool isActive;
  final String? ipAddress;
  final String? macAddress;
  final String? uptime;
  final int bytesIn;
  final int bytesOut;
  final String? limitUptime;
  final int limitBytesTotal;
  final String? comment;

  const SubscriberModel({
    required this.id,
    required this.username,
    this.password,
    required this.profile,
    required this.type,
    this.isDisabled = false,
    this.isActive = false,
    this.ipAddress,
    this.macAddress,
    this.uptime,
    this.bytesIn = 0,
    this.bytesOut = 0,
    this.limitUptime,
    this.limitBytesTotal = 0,
    this.comment,
  });

  bool get isExpired {
    if (limitBytesTotal > 0 && (bytesIn + bytesOut) >= limitBytesTotal) {
      return true;
    }
    return false;
  }
}

class PppoeActiveSession {
  final String id;
  final String name;
  final String service;
  final String callerId; // Client MAC or phone
  final String address;
  final String uptime;

  const PppoeActiveSession({
    required this.id,
    required this.name,
    required this.service,
    required this.callerId,
    required this.address,
    required this.uptime,
  });

  factory PppoeActiveSession.fromMap(Map<String, dynamic> map) {
    return PppoeActiveSession(
      id: map['.id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      service: map['service']?.toString() ?? 'pppoe',
      callerId: map['caller-id']?.toString() ?? '-',
      address: map['address']?.toString() ?? '-',
      uptime: map['uptime']?.toString() ?? '-',
    );
  }
}

class CardDiagnosisResult {
  final String cardName;
  final bool exists;
  final SubscriberModel? subscriber;
  final List<String> rankedFailureReasons;
  final Map<String, dynamic> rawAttributes;
  final bool isCurrentlyActive;
  final String? activeIp;
  final String? activeMac;

  const CardDiagnosisResult({
    required this.cardName,
    required this.exists,
    this.subscriber,
    required this.rankedFailureReasons,
    this.rawAttributes = const {},
    this.isCurrentlyActive = false,
    this.activeIp,
    this.activeMac,
  });
}

class SubscribersRepository {
  final AuditLogger _auditLogger;

  SubscribersRepository(this._auditLogger);

  /// Fetch Hotspot users and match with active sessions
  Future<List<SubscriberModel>> getHotspotSubscribers(
      RouterOsAdapter adapter) async {
    final usersRes = await adapter.getHotspotUsers();
    final activeRes = await adapter.getHotspotActive();

    final activeMap = <String, Map<String, dynamic>>{};
    for (final a in activeRes) {
      final user = a['user']?.toString() ?? '';
      if (user.isNotEmpty) {
        activeMap[user] = a;
      }
    }

    return usersRes.map((u) {
      final name = u['name']?.toString() ?? '';
      final active = activeMap[name];
      final bIn = int.tryParse(u['bytes-in']?.toString() ?? '0') ?? 0;
      final bOut = int.tryParse(u['bytes-out']?.toString() ?? '0') ?? 0;
      final limitBytes =
          int.tryParse(u['limit-bytes-total']?.toString() ?? '0') ?? 0;

      return SubscriberModel(
        id: u['.id']?.toString() ?? '',
        username: name,
        password: u['password']?.toString(),
        profile: u['profile']?.toString() ?? 'default',
        type: SubscriberType.hotspot,
        isDisabled: u['disabled']?.toString() == 'true' ||
            u['disabled']?.toString() == 'yes',
        isActive: active != null,
        ipAddress: active?['address']?.toString() ?? u['address']?.toString(),
        macAddress:
            active?['mac-address']?.toString() ?? u['mac-address']?.toString(),
        uptime: active?['uptime']?.toString() ?? u['uptime']?.toString(),
        bytesIn: bIn,
        bytesOut: bOut,
        limitUptime: u['limit-uptime']?.toString(),
        limitBytesTotal: limitBytes,
        comment: u['comment']?.toString(),
      );
    }).toList();
  }

  /// Fetch User Manager users and active sessions
  Future<List<SubscriberModel>> getUserManSubscribers(
      RouterOsAdapter adapter) async {
    final usersRes = await adapter.getUserManagerUsers();
    final sessionsRes = await adapter.getUserManagerSessions();

    final activeSessions = <String, Map<String, dynamic>>{};
    for (final s in sessionsRes) {
      final u = s['user']?.toString() ?? '';
      if (u.isNotEmpty && s['active'] != 'false') {
        activeSessions[u] = s;
      }
    }

    return usersRes.map((u) {
      final name = u['username']?.toString() ?? u['name']?.toString() ?? '';
      final session = activeSessions[name];

      return SubscriberModel(
        id: u['.id']?.toString() ?? '',
        username: name,
        password: u['password']?.toString(),
        profile: u['actual-profile']?.toString() ??
            u['profile']?.toString() ??
            'default',
        type: SubscriberType.userMan,
        isDisabled: u['disabled']?.toString() == 'true' ||
            u['disabled']?.toString() == 'yes',
        isActive: session != null,
        ipAddress: session?['nas-ip-address']?.toString() ??
            session?['host-ip']?.toString(),
        macAddress: session?['calling-station-id']?.toString(),
        uptime: session?['uptime']?.toString(),
        comment: u['comment']?.toString(),
      );
    }).toList();
  }

  /// Fetch PPPoE secrets and active sessions
  Future<List<SubscriberModel>> getPppoeSubscribers(
      RouterOsAdapter adapter) async {
    final secrets = await adapter.executeSentence(['/ppp/secret/print']);
    final active = await adapter.executeSentence(['/ppp/active/print']);

    final activeMap = <String, Map<String, dynamic>>{};
    if (active.isSuccess) {
      for (final a in active.data) {
        final name = a['name']?.toString() ?? '';
        if (name.isNotEmpty) activeMap[name] = a;
      }
    }

    if (!secrets.isSuccess) return [];

    return secrets.data.map((s) {
      final name = s['name']?.toString() ?? '';
      final currentActive = activeMap[name];

      return SubscriberModel(
        id: s['.id']?.toString() ?? '',
        username: name,
        password: s['password']?.toString(),
        profile: s['profile']?.toString() ?? 'default',
        type: SubscriberType.pppoe,
        isDisabled: s['disabled']?.toString() == 'true' ||
            s['disabled']?.toString() == 'yes',
        isActive: currentActive != null,
        ipAddress: currentActive?['address']?.toString() ??
            s['remote-address']?.toString(),
        macAddress: currentActive?['caller-id']?.toString(),
        uptime: currentActive?['uptime']?.toString(),
        comment: s['comment']?.toString(),
      );
    }).toList();
  }

  /// Kick PPPoE active session
  Future<bool> kickPppoeActive(RouterOsAdapter adapter, String username) async {
    final active =
        await adapter.executeSentence(['/ppp/active/print', '?name=$username']);
    if (active.isSuccess && active.data.isNotEmpty) {
      final id = active.data.first['.id'];
      if (id != null) {
        final res =
            await adapter.executeSentence(['/ppp/active/remove', '=.id=$id']);
        if (res.isSuccess) {
          await _auditLogger.log(
            action: 'kick',
            entityType: 'pppoe_active',
            entityId: username,
            description: 'قطع اتصال PPPoE للمشترك: $username',
          );
          return true;
        }
      }
    }
    return false;
  }

  /// Kick Hotspot active user
  Future<bool> kickHotspotActive(
      RouterOsAdapter adapter, String username) async {
    final active = await adapter
        .executeSentence(['/ip/hotspot/active/print', '?user=$username']);
    if (active.isSuccess && active.data.isNotEmpty) {
      final id = active.data.first['.id'];
      if (id != null) {
        final res = await adapter.kickHotspotActive(id);
        if (res) {
          await _auditLogger.log(
            action: 'kick',
            entityType: 'hotspot_active',
            entityId: username,
            description: 'قطع اتصال الهوتسبوت للمشترك: $username',
          );
          return true;
        }
      }
    }
    return false;
  }

  /// Toggle subscriber disabled state
  Future<bool> toggleSubscriberStatus(
      RouterOsAdapter adapter, SubscriberModel sub, bool enable) async {
    String cmd = '/ip/hotspot/user/set';
    if (sub.type == SubscriberType.userMan) {
      cmd = adapter.isV7
          ? '/user-manager/user/set'
          : '/tool/user-manager/user/set';
    } else if (sub.type == SubscriberType.pppoe) {
      cmd = '/ppp/secret/set';
    }

    final res = await adapter.executeSentence(
        [cmd, '=.id=${sub.id}', '=disabled=${enable ? 'no' : 'yes'}']);
    if (res.isSuccess) {
      await _auditLogger.log(
        action: enable ? 'enable_user' : 'disable_user',
        entityType: sub.type.name,
        entityId: sub.username,
        description: '${enable ? 'تفعيل' : 'تعطيل'} المشترك: ${sub.username}',
      );
      return true;
    }
    return false;
  }

  /// Reset MAC binding for a hotspot card
  Future<bool> resetMacBinding(RouterOsAdapter adapter, String username) async {
    final userRes = await adapter
        .executeSentence(['/ip/hotspot/user/print', '?name=$username']);
    if (userRes.isSuccess && userRes.data.isNotEmpty) {
      final id = userRes.data.first['.id'];
      if (id != null) {
        final res = await adapter.executeSentence([
          '/ip/hotspot/user/set',
          '=.id=$id',
          '=mac-address=',
        ]);
        if (res.isSuccess) {
          await _auditLogger.log(
            action: 'reset_mac',
            entityType: 'hotspot_user',
            entityId: username,
            description: 'فك ربط عنوان MAC للمشترك: $username',
          );
          return true;
        }
      }
    }
    return false;
  }

  /// Detailed diagnosis of card login failures
  Future<CardDiagnosisResult> diagnoseCard(
      RouterOsAdapter adapter, String cardName) async {
    final trimmed = cardName.trim();
    final List<String> reasons = [];

    // 1. Search in Hotspot users
    final res = await adapter
        .executeSentence(['/ip/hotspot/user/print', '?name=$trimmed']);
    if (!res.isSuccess || res.data.isEmpty) {
      // Check User Manager
      final umPath = adapter.isV7
          ? '/user-manager/user/print'
          : '/tool/user-manager/user/print';
      final umRes = await adapter.executeSentence([umPath, '?name=$trimmed']);
      if (!umRes.isSuccess || umRes.data.isEmpty) {
        return CardDiagnosisResult(
          cardName: trimmed,
          exists: false,
          rankedFailureReasons: [
            'الكرت غير موجود في قاعدة بيانات الراوتر (تحقق من الاسم أو أحرف الكرت).',
          ],
        );
      }
    }

    final data = res.data.first;
    final isDisabled = data['disabled'] == 'true';
    final limitUptime = data['limit-uptime']?.toString();
    final uptime = data['uptime']?.toString();
    final limitBytes =
        int.tryParse(data['limit-bytes-total']?.toString() ?? '0') ?? 0;
    final bIn = int.tryParse(data['bytes-in']?.toString() ?? '0') ?? 0;
    final bOut = int.tryParse(data['bytes-out']?.toString() ?? '0') ?? 0;
    final totalUsed = bIn + bOut;
    final boundMac = data['mac-address']?.toString() ?? '';
    final profile = data['profile']?.toString() ?? 'default';

    // 2. Check active session
    final activeRes = await adapter
        .executeSentence(['/ip/hotspot/active/print', '?user=$trimmed']);
    final isActive = activeRes.isSuccess && activeRes.data.isNotEmpty;
    final activeIp = isActive ? activeRes.data.first['address'] : null;
    final activeMac = isActive ? activeRes.data.first['mac-address'] : null;

    // Check Ranked Reasons:
    if (isDisabled) {
      reasons
          .add('الكرت معطل حالياً (Disabled). اضغط زر التفعيل لإعادة تشغيله.');
    }

    if (limitBytes > 0 && totalUsed >= limitBytes) {
      reasons.add(
          'استُهلك رصيد البيانات بالكامل (${_formatBytes(totalUsed)} من أصل ${_formatBytes(limitBytes)}).');
    }

    if (limitUptime != null && uptime != null && limitUptime.isNotEmpty) {
      if (uptime == limitUptime) {
        reasons.add(
            'انتهت المدة الزمنية المحددة للكرت بالكامل (Uptime limit reached: $limitUptime).');
      }
    }

    if (boundMac.isNotEmpty && boundMac != '00:00:00:00:00:00') {
      reasons.add(
          'الكرت مقيّد بعنوان MAC محدد ($boundMac). إذا حاول جهاز آخر الدخول سيتم رفضه (اضغط فك الربط).');
    }

    if (isActive) {
      reasons.add(
          'الكرت متصل حالياً بالفعل من جهاز آخر ($activeIp / $activeMac). إذا كانت الجلسات المشتركة 1 فلن يستطيع جهاز ثانٍ الدخول.');
    }

    if (reasons.isEmpty) {
      reasons.add(
          'الكرت سليم ومفعل داخل الراوتر. تأكد من إدخال كلمة المرور بدقة أو اتصال الجهاز بالشبكة الصحيحة.');
    }

    return CardDiagnosisResult(
      cardName: trimmed,
      exists: true,
      rankedFailureReasons: reasons,
      rawAttributes: data,
      isCurrentlyActive: isActive,
      activeIp: activeIp,
      activeMac: activeMac,
      subscriber: SubscriberModel(
        id: data['.id']?.toString() ?? '',
        username: trimmed,
        profile: profile,
        type: SubscriberType.hotspot,
        isDisabled: isDisabled,
        isActive: isActive,
        macAddress: boundMac.isNotEmpty ? boundMac : activeMac,
        ipAddress: activeIp,
        uptime: uptime,
        bytesIn: bIn,
        bytesOut: bOut,
        limitUptime: limitUptime,
        limitBytesTotal: limitBytes,
      ),
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 MB';
    final mb = bytes / (1024 * 1024);
    if (mb >= 1024) {
      return '${(mb / 1024).toStringAsFixed(2)} GB';
    }
    return '${mb.toStringAsFixed(1)} MB';
  }
}
