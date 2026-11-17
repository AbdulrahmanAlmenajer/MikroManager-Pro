import 'package:drift/drift.dart';

class AlertEventsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  IntColumn get ruleId => integer()();
  TextColumn get status => text()(); // confirmed, recovered
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();
  TextColumn get details => text().nullable()();

  @override
  String get tableName => 'alert_events';
}
