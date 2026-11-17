import 'package:drift/drift.dart';

class TopologySnapshotsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get graphJson => text()();
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'topology_snapshots';
}
