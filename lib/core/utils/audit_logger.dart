import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

final auditLoggerProvider = Provider<AuditLogger>((ref) {
  final db = ref.watch(databaseProvider);
  return AuditLogger(db);
});

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
    } on Object catch (e) {
      assert(false, 'AuditLogger write failed: $e');
    }
  }
}
