import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/network/routeros_adapter.dart';
import '../../../core/session/session_controller.dart';
import '../data/backup_repository.dart';

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BackupRepository(db);
});

class BackupState {
  final List<BackupLogTableData> history;
  final bool isProcessing;
  final String? lastSuccessMessage;
  final String? lastExportedFilePath;
  final String? errorMessage;

  const BackupState({
    this.history = const [],
    this.isProcessing = false,
    this.lastSuccessMessage,
    this.lastExportedFilePath,
    this.errorMessage,
  });

  BackupState copyWith({
    List<BackupLogTableData>? history,
    bool? isProcessing,
    String? lastSuccessMessage,
    String? lastExportedFilePath,
    String? errorMessage,
  }) {
    return BackupState(
      history: history ?? this.history,
      isProcessing: isProcessing ?? this.isProcessing,
      lastSuccessMessage: lastSuccessMessage,
      lastExportedFilePath: lastExportedFilePath,
      errorMessage: errorMessage,
    );
  }
}

class BackupNotifier extends StateNotifier<BackupState> {
  final BackupRepository _repo;

  BackupNotifier(this._repo) : super(const BackupState());

  Future<void> loadHistory(int connectionId) async {
    try {
      final list = await _repo.getBackupHistory(connectionId);
      state = state.copyWith(history: list);
    } catch (_) {}
  }

  Future<BackupResult> exportAppData(int connectionId) async {
    state = state.copyWith(
        isProcessing: true, errorMessage: null, lastSuccessMessage: null);
    final result = await _repo.exportAppDataBackup(connectionId);
    if (result.isSuccess) {
      state = state.copyWith(
        isProcessing: false,
        lastSuccessMessage: 'تم تصدير النسخة الاحتياطية بنجاح!',
        lastExportedFilePath: result.path,
      );
      await loadHistory(connectionId);
    } else {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'فشل التصدير: ${result.errorMessage}',
      );
    }
    return result;
  }

  Future<bool> restoreAppData(int connectionId, String jsonContent) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    final ok = await _repo.restoreAppDataBackup(jsonContent);
    if (ok) {
      state = state.copyWith(
        isProcessing: false,
        lastSuccessMessage: 'تمت استعادة البيانات بنجاح!',
      );
      await loadHistory(connectionId);
      return true;
    } else {
      state = state.copyWith(
        isProcessing: false,
        errorMessage:
            'فشلت الاستعادة: تأكد من صحة وسلامة ملف النسخة الاحتياطية.',
      );
      return false;
    }
  }

  Future<BackupResult> backupRouter(
    RouterOsAdapter adapter,
    int connectionId, {
    bool isScriptExport = false,
  }) async {
    state = state.copyWith(
        isProcessing: true, errorMessage: null, lastSuccessMessage: null);
    final result = await _repo.createRouterBackup(
      adapter: adapter,
      connectionId: connectionId,
      isScriptExport: isScriptExport,
    );
    if (result.isSuccess) {
      state = state.copyWith(
        isProcessing: false,
        lastSuccessMessage:
            'تم إنشاء ملف النسخة الاحتياطية في الراوتر بنجاح: ${result.path}',
      );
      await loadHistory(connectionId);
    } else {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'تعذر إنشاء نسخة الراوتر: ${result.errorMessage}',
      );
    }
    return result;
  }

  Future<void> deleteHistoryItem(int id, int connectionId) async {
    await _repo.deleteBackupLog(id);
    await loadHistory(connectionId);
  }
}

final backupNotifierProvider =
    StateNotifierProvider<BackupNotifier, BackupState>((ref) {
  final repo = ref.watch(backupRepositoryProvider);
  final notifier = BackupNotifier(repo);

  final session = ref.watch(sessionControllerProvider).session;
  if (session != null) {
    notifier.loadHistory(session.connectionId);
  }

  return notifier;
});
