import 'package:drift/drift.dart';

class ProfilePricesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get profileName => text()();
  RealColumn get price => real()();
  TextColumn get currency => text().withDefault(const Constant('YER'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'profile_prices';
}
