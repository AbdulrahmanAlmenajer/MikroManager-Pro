import 'package:drift/drift.dart';

/// Local cache of User Manager profiles fetched from router
class UmProfilesCacheTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get profileName => text().withLength(max: 128)();
  TextColumn get owner => text().withDefault(const Constant('admin'))();
  TextColumn get validity => text().withDefault(const Constant(''))();
  TextColumn get price => text().withDefault(const Constant('0'))();
  TextColumn get rawJson => text().withDefault(const Constant('{}'))();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
}
