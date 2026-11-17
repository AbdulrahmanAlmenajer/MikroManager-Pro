import 'package:drift/drift.dart';

class PaymentsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get receivedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'payments';
}
