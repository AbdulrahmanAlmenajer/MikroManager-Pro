import 'package:drift/drift.dart';

/// Log of User Manager health diagnostic check results
class UmDiagnosticsLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get checkKey => text().withLength(max: 128)();

  /// pass | warn | fail | unknown
  TextColumn get status => text().withDefault(const Constant('unknown'))();
  TextColumn get details => text().withDefault(const Constant(''))();
  DateTimeColumn get checkedAt => dateTime().withDefault(currentDateAndTime)();
}
