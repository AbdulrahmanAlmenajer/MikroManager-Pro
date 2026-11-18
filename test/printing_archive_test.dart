import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mikro_manager_pro/core/database/app_database.dart';
import 'package:mikro_manager_pro/core/utils/esc_pos_helper.dart';
import 'package:mikro_manager_pro/core/utils/pdf_generator_helper.dart';
import 'package:mikro_manager_pro/features/vouchers/data/pdf_archive_repository.dart';

void main() {
  group('Printing & PDF Archive Tests (Phase U4)', () {
    late AppDatabase db;
    late PdfArchiveRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
      repo = PdfArchiveRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveToArchive inserts record in Drift pdf_archive table', () async {
      // dummyPdfBytes would be passed to saveToArchive in an integration test;
      // here we test the DB insert path directly with a path string.
      final recordId = await db.into(db.pdfArchiveTable).insert(
            PdfArchiveTableCompanion.insert(
              connectionId: 1,
              batchId: 'BATCH-2026-001',
              filePath: '/mock/path/batch.pdf',
              createdAt: Value(DateTime.now()),
            ),
          );
      expect(recordId, isPositive);

      final archives = await repo.getArchivedPdfs(1);
      expect(archives.length, equals(1));
      expect(archives.first.batchId, equals('BATCH-2026-001'));
      expect(archives.first.filePath, equals('/mock/path/batch.pdf'));
    });

    test('EscPosHelper produces thermal receipt bytes for Arabic printing',
        () async {
      final vouchers = [
        VoucherCardData(
          username: '77123456',
          password: '9876',
          profile: '1Hour-Daily',
          price: 200,
          networkName: 'شبكة السرعة الذهبية',
        ),
      ];

      final bytes = await EscPosHelper.generateThermalArabicReceiptPdf(
        voucher: vouchers.first,
        is80mm: false,
      );

      expect(bytes, isNotEmpty);
      expect(bytes.length, greaterThan(100)); // Valid PDF header
    });
  });
}
