import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/tasks/task_runner.dart';

void main() {
  late AppDatabase db;
  late TaskRunner taskRunner;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    taskRunner = TaskRunner(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TaskRunner Unit Tests (Phase U2)', () {
    test('createCheckpoint and updateProgress persist state accurately',
        () async {
      final id = await taskRunner.createCheckpoint(
        taskId: 'batch_001',
        connectionId: 10,
        taskType: 'voucher_generation',
        totalItems: 500,
        payload: {'profile': '1Hour', 'prefix': '77'},
      );
      expect(id, isPositive);

      var tasks = await taskRunner.getIncompleteTasks(10);
      expect(tasks.length, equals(1));
      expect(tasks.first.totalItems, equals(500));
      expect(tasks.first.processedItems, equals(0));
      expect(tasks.first.status, equals('running'));
      expect(tasks.first.progress, equals(0.0));

      // Simulate partial progress: 250 items processed
      await taskRunner.updateProgress(
        checkpointId: id,
        processed: 250,
        succeeded: 250,
        failed: 0,
      );

      tasks = await taskRunner.getIncompleteTasks(10);
      expect(tasks.first.processedItems, equals(250));
      expect(tasks.first.progress, equals(0.5));

      // Mark complete
      await taskRunner.completeCheckpoint(id);
      tasks = await taskRunner.getIncompleteTasks(10);
      expect(tasks, isEmpty);
    });

    test('failCheckpoint records error in payload and marks status failed',
        () async {
      final id = await taskRunner.createCheckpoint(
        taskId: 'batch_002',
        connectionId: 20,
        taskType: 'voucher_generation',
        totalItems: 100,
      );

      await taskRunner.failCheckpoint(id, 'Router connection lost at card 45');

      final tasks = await taskRunner.getIncompleteTasks(20);
      expect(tasks.length, equals(1));
      expect(tasks.first.status, equals('failed'));
      expect(tasks.first.payload['last_error'],
          equals('Router connection lost at card 45'));
    });
  });
}
