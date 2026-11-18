import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class TaskCheckpointInfo {
  final int id;
  final String taskId;
  final int connectionId;
  final String taskType;
  final int totalItems;
  final int processedItems;
  final int succeededItems;
  final int failedItems;
  final String status;
  final Map<String, dynamic> payload;
  final DateTime updatedAt;

  TaskCheckpointInfo({
    required this.id,
    required this.taskId,
    required this.connectionId,
    required this.taskType,
    required this.totalItems,
    required this.processedItems,
    required this.succeededItems,
    required this.failedItems,
    required this.status,
    required this.payload,
    required this.updatedAt,
  });

  double get progress =>
      totalItems > 0 ? (processedItems / totalItems).clamp(0.0, 1.0) : 0.0;
}

class TaskRunner {
  final AppDatabase _db;

  TaskRunner(this._db);

  /// Create a new checkpoint record for a long-running batch
  Future<int> createCheckpoint({
    required String taskId,
    required int connectionId,
    required String taskType,
    required int totalItems,
    Map<String, dynamic> payload = const {},
  }) async {
    return await _db.into(_db.taskCheckpointsTable).insert(
          TaskCheckpointsTableCompanion.insert(
            taskId: taskId,
            connectionId: connectionId,
            taskType: taskType,
            totalItems: Value(totalItems),
            processedItems: const Value(0),
            succeededItems: const Value(0),
            failedItems: const Value(0),
            payload: Value(jsonEncode(payload)),
            status: const Value('running'),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Update incremental progress
  Future<void> updateProgress({
    required int checkpointId,
    required int processed,
    required int succeeded,
    required int failed,
    String status = 'running',
  }) async {
    await (_db.update(_db.taskCheckpointsTable)
          ..where((t) => t.id.equals(checkpointId)))
        .write(
      TaskCheckpointsTableCompanion(
        processedItems: Value(processed),
        succeededItems: Value(succeeded),
        failedItems: Value(failed),
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark checkpoint as completed
  Future<void> completeCheckpoint(int checkpointId) async {
    await (_db.update(_db.taskCheckpointsTable)
          ..where((t) => t.id.equals(checkpointId)))
        .write(
      TaskCheckpointsTableCompanion(
        status: const Value('completed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark checkpoint as failed with error details in payload
  Future<void> failCheckpoint(int checkpointId, String error) async {
    final existing = await (_db.select(_db.taskCheckpointsTable)
          ..where((t) => t.id.equals(checkpointId)))
        .getSingleOrNull();

    Map<String, dynamic> pMap = {};
    if (existing != null) {
      try {
        pMap = Map<String, dynamic>.from(jsonDecode(existing.payload) as Map);
      } on Object catch (_) {}
    }
    pMap['last_error'] = error;

    await (_db.update(_db.taskCheckpointsTable)
          ..where((t) => t.id.equals(checkpointId)))
        .write(
      TaskCheckpointsTableCompanion(
        status: const Value('failed'),
        payload: Value(jsonEncode(pMap)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Find active or interrupted batches for a connection
  Future<List<TaskCheckpointInfo>> getIncompleteTasks(int connectionId) async {
    final rows = await (_db.select(_db.taskCheckpointsTable)
          ..where((t) =>
              t.connectionId.equals(connectionId) &
              t.status.isIn(['running', 'failed']))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();

    return rows.map((r) {
      Map<String, dynamic> pMap = {};
      try {
        pMap = Map<String, dynamic>.from(jsonDecode(r.payload) as Map);
      } on Object catch (_) {}
      return TaskCheckpointInfo(
        id: r.id,
        taskId: r.taskId,
        connectionId: r.connectionId,
        taskType: r.taskType,
        totalItems: r.totalItems,
        processedItems: r.processedItems,
        succeededItems: r.succeededItems,
        failedItems: r.failedItems,
        status: r.status,
        payload: pMap,
        updatedAt: r.updatedAt,
      );
    }).toList();
  }

  /// Watch incomplete tasks
  Stream<List<TaskCheckpointInfo>> watchIncompleteTasks(int connectionId) {
    return (_db.select(_db.taskCheckpointsTable)
          ..where((t) =>
              t.connectionId.equals(connectionId) &
              t.status.isIn(['running', 'failed']))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((rows) {
      return rows.map((r) {
        Map<String, dynamic> pMap = {};
        try {
          pMap = Map<String, dynamic>.from(jsonDecode(r.payload) as Map);
        } on Object catch (_) {}
        return TaskCheckpointInfo(
          id: r.id,
          taskId: r.taskId,
          connectionId: r.connectionId,
          taskType: r.taskType,
          totalItems: r.totalItems,
          processedItems: r.processedItems,
          succeededItems: r.succeededItems,
          failedItems: r.failedItems,
          status: r.status,
          payload: pMap,
          updatedAt: r.updatedAt,
        );
      }).toList();
    });
  }
}

final taskRunnerProvider = Provider<TaskRunner>((ref) {
  final db = ref.watch(databaseProvider);
  return TaskRunner(db);
});
