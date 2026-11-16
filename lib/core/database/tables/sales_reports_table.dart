import 'package:drift/drift.dart';

class SalesReportsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routerId => integer().nullable()();
  TextColumn get reportType => text()(); // daily, monthly
  DateTimeColumn get reportDate => dateTime()();
  IntColumn get totalVouchers => integer().withDefault(const Constant(0))();
  RealColumn get totalRevenue => real().withDefault(const Constant(0.0))();
  RealColumn get totalCost => real().withDefault(const Constant(0.0))();
  RealColumn get netProfit => real().withDefault(const Constant(0.0))();
  TextColumn get detailsJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'sales_reports_cache';
}
