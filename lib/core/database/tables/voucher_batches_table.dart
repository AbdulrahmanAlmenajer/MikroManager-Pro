import 'package:drift/drift.dart';

class VoucherBatchesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routerId => integer()();
  TextColumn get profileName => text()();
  IntColumn get quantity => integer()();
  TextColumn get prefix => text().withDefault(const Constant(''))();
  IntColumn get codeLength => integer().withDefault(const Constant(8))();
  TextColumn get vouchersJson => text()(); // JSON array of voucher codes
  RealColumn get unitPrice => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('generated'))();
  TextColumn get notes => text().nullable()();
  TextColumn get systemType =>
      text().withDefault(const Constant('hotspot'))(); // 'hotspot', 'usermanV6', 'usermanV7'
  TextColumn get serialPrefix => text().nullable()();
  IntColumn get serialStart => integer().nullable()();
  IntColumn get serialPadding => integer().nullable()();
  IntColumn get serialEnd => integer().nullable()();
  DateTimeColumn get generatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get printedAt => dateTime().nullable()();

  @override
  String get tableName => 'voucher_batches';
}
