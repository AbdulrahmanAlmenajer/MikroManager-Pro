import 'package:drift/drift.dart';

class VoucherTemplatesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get paperSize => text().withDefault(const Constant('A4'))(); // A4, 58mm, 80mm
  IntColumn get cardsPerRow => integer().withDefault(const Constant(3))();
  IntColumn get cardsPerPage => integer().withDefault(const Constant(12))();
  BoolColumn get showQrCode => boolean().withDefault(const Constant(true))();
  BoolColumn get showLogo => boolean().withDefault(const Constant(false))();
  TextColumn get logoPath => text().nullable()();
  TextColumn get headerText => text().nullable()();
  TextColumn get footerText => text().nullable()();
  IntColumn get primaryColorHex => integer().withDefault(const Constant(0xFF0F172A))();
  TextColumn get fontFamily => text().withDefault(const Constant('Cairo'))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'voucher_templates';
}
