import 'package:drift/drift.dart';

class BackupLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get kind => text()(); // app_data, router_config, userman
  TextColumn get path => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'backup_log';
}
