import 'package:drift/drift.dart';

class VoucherTemplatesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get paperSize =>
      text().withDefault(const Constant('A4'))(); // A4, 58mm, 80mm
  IntColumn get cardsPerRow => integer().withDefault(const Constant(3))();
  IntColumn get cardsPerPage => integer().withDefault(const Constant(12))();
  RealColumn get cardWidthMm => real().nullable()();
  RealColumn get cardHeightMm => real().nullable()();
  RealColumn get marginMm => real().withDefault(const Constant(4.0))();
  RealColumn get fontSize => real().withDefault(const Constant(10.0))();
  RealColumn get titleFontSize => real().withDefault(const Constant(12.0))();
  IntColumn get primaryColorHex =>
      integer().withDefault(const Constant(0xFF0F172A))();
  IntColumn get backgroundColorHex =>
      integer().withDefault(const Constant(0xFFFFFFFF))();
  IntColumn get textColorHex =>
      integer().withDefault(const Constant(0xFF1E293B))();
  IntColumn get titleColorHex =>
      integer().withDefault(const Constant(0xFF0F172A))();
  IntColumn get borderColorHex =>
      integer().withDefault(const Constant(0xFFCBD5E1))();
  RealColumn get borderWidth => real().withDefault(const Constant(1.0))();
  RealColumn get borderRadius => real().withDefault(const Constant(8.0))();
  BoolColumn get showQrCode => boolean().withDefault(const Constant(true))();
  BoolColumn get showBarcode => boolean().withDefault(const Constant(false))();
  BoolColumn get showLogo => boolean().withDefault(const Constant(false))();
  TextColumn get logoPath => text().nullable()();
  TextColumn get headerText => text().nullable()();
  TextColumn get footerText => text().nullable()();
  TextColumn get fontFamily => text().withDefault(const Constant('Cairo'))();
  BoolColumn get showProfile => boolean().withDefault(const Constant(true))();
  BoolColumn get showPrice => boolean().withDefault(const Constant(true))();
  BoolColumn get showValidity => boolean().withDefault(const Constant(true))();
  BoolColumn get showUsername => boolean().withDefault(const Constant(true))();
  BoolColumn get showPassword => boolean().withDefault(const Constant(true))();
  BoolColumn get showInstructions =>
      boolean().withDefault(const Constant(false))();
  TextColumn get instructionsText => text().nullable()();
  TextColumn get contactPhone => text().nullable()();
  TextColumn get customText => text().nullable()();
  TextColumn get targetCardType => text()
      .withDefault(const Constant('all'))(); // 'all', 'hotspot', 'usermanager'
  TextColumn get configJson => text().nullable()(); // Dynamic JSON config
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'voucher_templates';
}
