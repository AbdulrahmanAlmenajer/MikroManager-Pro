import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/routers_table.dart';
import 'tables/voucher_batches_table.dart';
import 'tables/voucher_templates_table.dart';
import 'tables/sales_reports_table.dart';
import 'tables/audit_logs_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    RoutersTable,
    VoucherBatchesTable,
    VoucherTemplatesTable,
    SalesReportsTable,
    AuditLogsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Insert default voucher template
        await into(voucherTemplatesTable).insert(
          VoucherTemplatesTableCompanion.insert(
            name: 'القالب الافتراضي A4',
            paperSize: const Value('A4'),
            cardsPerRow: const Value(3),
            cardsPerPage: const Value(12),
            showQrCode: const Value(true),
            isDefault: const Value(true),
          ),
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mikro_manager.db'));
    return NativeDatabase.createInBackground(file);
  });
}
