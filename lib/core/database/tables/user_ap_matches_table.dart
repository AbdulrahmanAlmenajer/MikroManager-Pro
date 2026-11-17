import 'package:drift/drift.dart';

class UserApMatchesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get userMac => text()();
  IntColumn get apId => integer().nullable()();
  TextColumn get confidence => text()(); // confirmed, likely, unmatched
  TextColumn get evidence => text()();
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'user_ap_matches';
}
