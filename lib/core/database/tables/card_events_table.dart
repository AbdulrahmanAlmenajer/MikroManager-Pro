import 'package:drift/drift.dart';

class CardEventsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get type => text()(); // 'generated', 'deleted'
  IntColumn get count => integer()();
  TextColumn get profile => text()();
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'card_events';
}
