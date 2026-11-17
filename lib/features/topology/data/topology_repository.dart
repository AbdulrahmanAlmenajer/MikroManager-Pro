import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../subscribers/data/subscribers_repository.dart';

class UserApMatchResult {
  final String username;
  final String? ipAddress;
  final String? macAddress;
  final int? apId;
  final String? apName;
  final String confidence; // 'confirmed', 'likely', 'unmatched'
  final String evidence;

  const UserApMatchResult({
    required this.username,
    this.ipAddress,
    this.macAddress,
    this.apId,
    this.apName,
    required this.confidence,
    required this.evidence,
  });
}

class TopologyRepository {
  final AppDatabase _db;

  TopologyRepository(this._db);

  // =========================================================================
  // Evidence Ladder: Match Active Subscribers to AP Devices
  // =========================================================================

  Future<List<UserApMatchResult>> matchSubscribersToAps({
    required int connectionId,
    required List<SubscriberModel> subscribers,
    required List<ApDevicesTableData> aps,
  }) async {
    final List<UserApMatchResult> results = [];

    // Map APs by IP prefix (e.g. 192.168.88.x -> AP)
    final Map<String, ApDevicesTableData> subnetMap = {};
    for (final ap in aps) {
      final parts = ap.ip.split('.');
      if (parts.length == 4) {
        final prefix = '${parts[0]}.${parts[1]}.${parts[2]}';
        subnetMap[prefix] = ap;
      }
    }

    for (final sub in subscribers) {
      // We only match active/online subscribers or those with an assigned IP
      if (!sub.isActive && sub.ipAddress == null) {
        continue;
      }

      int? matchedApId;
      String? matchedApName;
      String confidence = 'unmatched';
      String evidence = 'لم يتم العثور على أكسس بوينت مطابق في نفس النطاق';

      final userIp = sub.ipAddress;
      final userMac = sub.macAddress ?? '';
      final comment = sub.comment?.toLowerCase() ?? '';

      // 1. Direct match by explicit AP name in subscriber comment or binding
      ApDevicesTableData? directMatch;
      for (final ap in aps) {
        if (comment.contains(ap.name.toLowerCase()) || comment.contains(ap.ip)) {
          directMatch = ap;
          break;
        }
      }

      if (directMatch != null) {
        matchedApId = directMatch.id;
        matchedApName = directMatch.name;
        confidence = 'confirmed';
        evidence = 'تم التأكيد بناءً على تسمية الربط المباشرة مع الأكسس (${directMatch.name})';
      } else if (userIp != null && userIp.isNotEmpty) {
        // 2. Subnet correlation
        final ipParts = userIp.split('.');
        if (ipParts.length == 4) {
          final prefix = '${ipParts[0]}.${ipParts[1]}.${ipParts[2]}';
          final apOnSubnet = subnetMap[prefix];
          if (apOnSubnet != null) {
            matchedApId = apOnSubnet.id;
            matchedApName = apOnSubnet.name;
            confidence = 'likely';
            evidence = 'نطاق IP مطابق لعنوان الأكسس ($prefix.0/24)';
          }
        }
      }

      // Record match in Drift table
      if (userMac.isNotEmpty) {
        await _recordMatch(
          connectionId: connectionId,
          userMac: userMac,
          apId: matchedApId,
          confidence: confidence,
          evidence: evidence,
        );
      }

      results.add(
        UserApMatchResult(
          username: sub.username,
          ipAddress: userIp,
          macAddress: userMac.isNotEmpty ? userMac : null,
          apId: matchedApId,
          apName: matchedApName,
          confidence: confidence,
          evidence: evidence,
        ),
      );
    }

    return results;
  }

  Future<void> _recordMatch({
    required int connectionId,
    required String userMac,
    int? apId,
    required String confidence,
    required String evidence,
  }) async {
    final existing = await (_db.select(_db.userApMatchesTable)
          ..where((t) => t.connectionId.equals(connectionId) & t.userMac.equals(userMac)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.userApMatchesTable)..where((t) => t.id.equals(existing.id))).write(
        UserApMatchesTableCompanion(
          apId: Value(apId),
          confidence: Value(confidence),
          evidence: Value(evidence),
          at: Value(DateTime.now()),
        ),
      );
    } else {
      await _db.into(_db.userApMatchesTable).insert(
        UserApMatchesTableCompanion.insert(
          connectionId: connectionId,
          userMac: userMac,
          apId: Value(apId),
          confidence: confidence,
          evidence: evidence,
        ),
      );
    }
  }

  // =========================================================================
  // Snapshots Management
  // =========================================================================

  Future<int> saveSnapshot({
    required int connectionId,
    required Map<String, dynamic> graphData,
  }) async {
    final jsonStr = jsonEncode(graphData);
    return await _db.into(_db.topologySnapshotsTable).insert(
      TopologySnapshotsTableCompanion.insert(
        connectionId: connectionId,
        graphJson: jsonStr,
        savedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<Map<String, dynamic>?> getLatestSnapshot(int connectionId) async {
    final record = await (_db.select(_db.topologySnapshotsTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm(expression: t.savedAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();

    if (record == null) return null;
    try {
      return jsonDecode(record.graphJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
