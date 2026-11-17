import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

class PdfArchiveRepository {
  final AppDatabase _db;

  PdfArchiveRepository(this._db);

  /// Saves generated PDF bytes to local disk and records in Drift pdf_archive table
  Future<int> saveToArchive({
    required int connectionId,
    required String batchId,
    required Uint8List pdfBytes,
    int? templateId,
  }) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final archiveDir = Directory(p.join(docsDir.path, 'pdf_archive'));
    if (!await archiveDir.exists()) {
      await archiveDir.create(recursive: true);
    }

    final sanitizedBatch = batchId.replaceAll(RegExp(r'[^\w\-]'), '_');
    final filePath = p.join(archiveDir.path, 'batch_${sanitizedBatch}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    return await _db.into(_db.pdfArchiveTable).insert(
      PdfArchiveTableCompanion.insert(
        connectionId: connectionId,
        batchId: batchId,
        filePath: filePath,
        templateId: Value(templateId),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  /// Watch or get archived PDFs for connection
  Stream<List<PdfArchiveTableData>> watchArchivedPdfs(int connectionId) {
    return (_db.select(_db.pdfArchiveTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<PdfArchiveTableData>> getArchivedPdfs(int connectionId) async {
    return await (_db.select(_db.pdfArchiveTable)
          ..where((t) => t.connectionId.equals(connectionId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Delete archived PDF file and record
  Future<bool> deleteArchive(int id) async {
    final record = await (_db.select(_db.pdfArchiveTable)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (record != null) {
      final file = File(record.filePath);
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {}
      }
      await (_db.delete(_db.pdfArchiveTable)..where((t) => t.id.equals(id))).go();
      return true;
    }
    return false;
  }
}

final pdfArchiveRepositoryProvider = Provider<PdfArchiveRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PdfArchiveRepository(db);
});
