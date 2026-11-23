import 'package:drift/drift.dart';

class CardSalesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get saleId =>
      text().unique()(); // UUID or timestamp token for idempotency
  TextColumn get cardType => text()
      .withDefault(const Constant('hotspot'))(); // 'hotspot' or 'usermanager'
  TextColumn get username => text()();
  TextColumn get profile => text()();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  RealColumn get cost => real().withDefault(const Constant(0.0))();
  TextColumn get soldBy => text().withDefault(const Constant('admin'))();
  TextColumn get paymentMethod =>
      text().withDefault(const Constant('cash'))(); // cash, transfer, card
  TextColumn get status =>
      text().withDefault(const Constant('completed'))(); // completed, refunded
  TextColumn get customerName => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isPrinted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get soldAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'card_sales';
}
