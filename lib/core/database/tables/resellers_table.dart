import 'package:drift/drift.dart';

/// Resellers ledger — one row per reseller account
class ResellersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get name => text().withLength(max: 128)();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
