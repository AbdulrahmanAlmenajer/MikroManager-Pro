import 'package:drift/drift.dart';

class InterfaceDailyTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get interface => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get rxBytes => integer().withDefault(const Constant(0))();
  IntColumn get txBytes => integer().withDefault(const Constant(0))();

  @override
  String get tableName => 'interface_daily';
}
