import 'package:drift/drift.dart';

class PdfArchiveTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectionId => integer()();
  TextColumn get batchId => text()();
  TextColumn get filePath => text()();
  IntColumn get templateId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'pdf_archive';
}
