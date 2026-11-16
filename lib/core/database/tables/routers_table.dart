import 'package:drift/drift.dart';

class RoutersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get ipAddress => text()();
  IntColumn get apiPort => integer().withDefault(const Constant(8728))();
  TextColumn get username => text().withDefault(const Constant('admin'))();
  BoolColumn get useSsl => boolean().withDefault(const Constant(false))();
  BoolColumn get useRestApi => boolean().withDefault(const Constant(false))();
  TextColumn get routerOsVersion => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastConnectedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  String get tableName => 'routers';
}
