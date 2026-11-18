import 'package:drift/drift.dart';

/// Cash settlements (payments received from resellers).
/// NEVER mix currencies — each row is a single-currency entry.
class ResellerSettlementsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get resellerId => integer()();

  /// ISO 4217 currency code — MUST match allocation currency
  TextColumn get currency => text().withLength(max: 8)();
  RealColumn get amountPaid => real()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get settledAt => dateTime().withDefault(currentDateAndTime)();
}
