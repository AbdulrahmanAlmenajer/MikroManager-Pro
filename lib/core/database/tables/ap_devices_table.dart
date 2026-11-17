import 'package:drift/drift.dart';

class ApDevicesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get name => text()();
  TextColumn get ip => text()();
  TextColumn get vendor => text().withDefault(const Constant('MikroTik'))();
  DateTimeColumn get lastCheckAt => dateTime().nullable()();
  TextColumn get accessState => text().withDefault(const Constant('unknown'))(); // ok, unreachable, bad_credentials, unknown

  @override
  String get tableName => 'ap_devices';
}
