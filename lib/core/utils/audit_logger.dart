import 'package:drift/drift.dart';
import '../database/app_database.dart';

class AuditLogger {
  final AppDatabase _db;

  AuditLogger(this._db);

  Future<void> log({
    required String action,
    required String entityType,
    String? entityId,
    required String description,
    String performedBy = 'admin',
    String? metadata,
  }) async {
    try {
      await _db.into(_db.auditLogsTable).insert(
        AuditLogsTableCompanion.insert(
          action: action,
          entityType: entityType,
          entityId: Value(entityId),
          description: description,
          performedBy: Value(performedBy),
          metadata: Value(metadata),
          performedAt: Value(DateTime.now()),
        ),
      );
    } catch (_) {}
  }
}
