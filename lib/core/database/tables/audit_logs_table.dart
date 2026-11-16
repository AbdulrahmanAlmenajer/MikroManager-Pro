import 'package:drift/drift.dart';

class AuditLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => text()(); // generate, delete, print, kick, add_user
  TextColumn get entityType => text()(); // voucher, user, router, session
  TextColumn get entityId => text().nullable()();
  TextColumn get description => text()();
  TextColumn get performedBy => text().withDefault(const Constant('admin'))();
  TextColumn get metadata => text().nullable()(); // JSON
  DateTimeColumn get performedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'audit_logs';
}
