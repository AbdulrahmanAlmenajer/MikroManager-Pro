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
import 'tables/profile_prices_table.dart';
import 'tables/usage_observations_table.dart';
import 'tables/card_events_table.dart';
import 'tables/payments_table.dart';
import 'tables/pdf_archive_table.dart';
import 'tables/ap_devices_table.dart';
import 'tables/user_ap_matches_table.dart';
import 'tables/topology_snapshots_table.dart';
import 'tables/alert_rules_table.dart';
import 'tables/alert_events_table.dart';
import 'tables/quiet_hours_table.dart';
import 'tables/trusted_dhcp_servers_table.dart';
import 'tables/interface_daily_table.dart';
import 'tables/backup_log_table.dart';
// v4.0 new tables
import 'tables/task_checkpoints_table.dart';
import 'tables/um_profiles_cache_table.dart';
import 'tables/um_diagnostics_log_table.dart';
import 'tables/resellers_table.dart';
import 'tables/reseller_allocations_table.dart';
import 'tables/reseller_settlements_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    RoutersTable,
    VoucherBatchesTable,
    VoucherTemplatesTable,
    SalesReportsTable,
    AuditLogsTable,
    ProfilePricesTable,
    UsageObservationsTable,
    CardEventsTable,
    PaymentsTable,
    PdfArchiveTable,
    ApDevicesTable,
    UserApMatchesTable,
    TopologySnapshotsTable,
    AlertRulesTable,
    AlertEventsTable,
    QuietHoursTable,
    TrustedDhcpServersTable,
    InterfaceDailyTable,
    BackupLogTable,
    // v4.0 new tables
    TaskCheckpointsTable,
    UmProfilesCacheTable,
    UmDiagnosticsLogTable,
    ResellersTable,
    ResellerAllocationsTable,
    ResellerSettlementsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Enforce foreign keys if needed
      },
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
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // 1. Safe backup of existing database before upgrading
          try {
            final dbFolder = await getApplicationDocumentsDirectory();
            final dbFile = File(p.join(dbFolder.path, 'mikro_manager.db'));
            if (await dbFile.exists()) {
              final backupPath =
                  p.join(dbFolder.path, 'mikro_manager.db.v$from.bak');
              await dbFile.copy(backupPath);
            }
          } on FileSystemException catch (e) {
            // Log but do NOT block migration -- backup failure must not break upgrade
            assert(false,
                'DB backup before migration failed (non-fatal): ${e.message}');
          }

          // 2. Create the 14 new tables introduced in v3.1
          await m.createTable(profilePricesTable);
          await m.createTable(usageObservationsTable);
          await m.createTable(cardEventsTable);
          await m.createTable(paymentsTable);
          await m.createTable(pdfArchiveTable);
          await m.createTable(apDevicesTable);
          await m.createTable(userApMatchesTable);
          await m.createTable(topologySnapshotsTable);
          await m.createTable(alertRulesTable);
          await m.createTable(alertEventsTable);
          await m.createTable(quietHoursTable);
          await m.createTable(trustedDhcpServersTable);
          await m.createTable(interfaceDailyTable);
          await m.createTable(backupLogTable);
        }
        if (from < 3) {
          // v4.0 -- 6 new tables for TaskRunner, UM cache, Resellers ledger
          await m.createTable(taskCheckpointsTable);
          await m.createTable(umProfilesCacheTable);
          await m.createTable(umDiagnosticsLogTable);
          await m.createTable(resellersTable);
          await m.createTable(resellerAllocationsTable);
          await m.createTable(resellerSettlementsTable);
        }
      },
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
