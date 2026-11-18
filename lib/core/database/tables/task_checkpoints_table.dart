import 'package:drift/drift.dart';

/// Tracks long-running batch operations (e.g., voucher creation)
/// so they can be resumed after disconnects.
class TaskCheckpointsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskId => text().withLength(max: 128)();
  IntColumn get connectionId => integer()();
  TextColumn get taskType => text().withLength(max: 64)();
  IntColumn get totalItems => integer().withDefault(const Constant(0))();
  IntColumn get processedItems => integer().withDefault(const Constant(0))();
  IntColumn get succeededItems => integer().withDefault(const Constant(0))();
  IntColumn get failedItems => integer().withDefault(const Constant(0))();
  TextColumn get payload => text().withDefault(const Constant('{}'))();

  /// running | completed | cancelled | failed
  TextColumn get status => text().withDefault(const Constant('running'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
