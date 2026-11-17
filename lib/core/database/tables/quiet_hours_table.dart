import 'package:drift/drift.dart';

class QuietHoursTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  IntColumn get startMinute => integer()(); // minutes from midnight (0 - 1439)
  IntColumn get endMinute => integer()();
  TextColumn get days => text().withDefault(const Constant('1,2,3,4,5,6,7'))();
  DateTimeColumn get muteUntil => dateTime().nullable()();

  @override
  String get tableName => 'quiet_hours';
}
