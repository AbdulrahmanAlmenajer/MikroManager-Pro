import 'package:drift/drift.dart';

class AlertRulesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get type => text()(); // cpu, memory, disk, port, ap, ping
  TextColumn get target => text()();
  RealColumn get threshold => real()();
  TextColumn get destination => text().withDefault(const Constant('phone'))(); // phone, telegram, both
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  String get tableName => 'alert_rules';
}
