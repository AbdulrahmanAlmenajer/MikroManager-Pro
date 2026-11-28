import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/tasks/task_runner.dart';
import 'package:mikro_manager_pro/core/utils/cancellation_token.dart';
import 'package:mikro_manager_pro/core/widgets/task_progress_widget.dart';
import 'package:mikro_manager_pro/features/reports/data/reports_repository.dart';
import 'package:mikro_manager_pro/features/subscribers/data/subscribers_repository.dart';

void main() {
  group('CancellationToken Tests', () {
    test('Token notifies listeners and throws OperationCancelledException', () {
      final token = CancellationToken();
      expect(token.isCancelled, isFalse);

      bool listenerCalled = false;
      token.addListener(() {
        listenerCalled = true;
      });

      token.throwIfCancelled(); // Should not throw

      token.cancel();
      expect(token.isCancelled, isTrue);
      expect(listenerCalled, isTrue);

      expect(() => token.throwIfCancelled(),
          throwsA(isA<OperationCancelledException>()));
    });

    test('Removed listener is not notified', () {
      final token = CancellationToken();
      bool listenerCalled = false;
      void listener() {
        listenerCalled = true;
      }

      token.addListener(listener);
      token.removeListener(listener);
      token.cancel();

      expect(listenerCalled, isFalse);
    });
  });

  group('TaskRunner Running Check Tests', () {
    late AppDatabase db;
    late TaskRunner taskRunner;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      taskRunner = TaskRunner(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('hasRunningTasks returns false when empty and true when checkpoint exists',
        () async {
      expect(await taskRunner.hasRunningTasks(), isFalse);

      // Create an active batch checkpoint
      await taskRunner.createCheckpoint(
        taskId: 'task_test_1',
        connectionId: 1,
        taskType: 'voucher_upload',
        totalItems: 50,
      );

      expect(await taskRunner.hasRunningTasks(), isTrue);

      // Cancel all running tasks
      await taskRunner.cancelAllRunningTasks();
      expect(await taskRunner.hasRunningTasks(), isFalse);
    });
  });

  group('TaskProgressState Tests', () {
    test('TaskProgressState computes correct properties', () {
      const state = TaskProgressState(
        currentStage: 2,
        totalStages: 3,
        stageTitle: 'حساب الإحصائيات',
        detailText: 'جاري مطابقة المبيعات...',
        progressPercent: 0.66,
      );

      expect(state.currentStage, 2);
      expect(state.totalStages, 3);
      expect(state.progressPercent, 0.66);
      expect(state.isCancelling, isFalse);

      final cancellingState = state.copyWith(isCancelling: true);
      expect(cancellingState.isCancelling, isTrue);
    });
  });

  group('Zero-Freeze Report Calculation Tests', () {
    late AppDatabase db;
    late ReportsRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      repo = ReportsRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('getHonestReportData executes without freeze and returns accurate data',
        () async {
      await repo.setProfilePrice(
        connectionId: 1,
        profileName: '1Hour',
        price: 100.0,
      );

      final subscribers = [
        const SubscriberModel(
          id: '*1',
          username: 'hs_user_1',
          profile: '1Hour',
          type: SubscriberType.hotspot,
          uptime: '10m',
          bytesIn: 1000,
          bytesOut: 2000,
        ),
        const SubscriberModel(
          id: '*2',
          username: 'um_user_1',
          profile: '1Hour',
          type: SubscriberType.userMan,
          uptime: '0s',
          bytesIn: 0,
          bytesOut: 0,
        ),
      ];

      final report = await repo.getHonestReportData(
        connectionId: 1,
        subscribers: subscribers,
      );

      expect(report.stock.totalCards, 2);
      expect(report.stock.activeCards, 1);
      expect(report.stock.unusedCards, 1);
      expect(report.stock.hotspotCardsCount, 1);
      expect(report.stock.userManCardsCount, 1);
      expect(report.profilePrices['1Hour'], 100.0);
    });
  });
}
