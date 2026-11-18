import 'package:drift/drift.dart';

class UsageObservationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get cardName => text()();
  TextColumn get profile => text()();
  DateTimeColumn get firstSeenAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get dateIsApproximate =>
      boolean().withDefault(const Constant(false))();

  @override
  String get tableName => 'usage_observations';
}
