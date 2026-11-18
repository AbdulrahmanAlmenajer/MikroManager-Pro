import 'package:drift/drift.dart';

/// Card/voucher allocations given to a reseller
class ResellerAllocationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get resellerId => integer()();
  TextColumn get batchId => text().withLength(max: 64)();
  TextColumn get profile => text().withLength(max: 128)();
  IntColumn get quantity => integer()();

  /// ISO 4217 currency code, e.g. YER, SAR, USD
  TextColumn get currency => text().withLength(max: 8)();
  RealColumn get unitPrice => real()();
  RealColumn get totalValue => real()();
  DateTimeColumn get allocatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
