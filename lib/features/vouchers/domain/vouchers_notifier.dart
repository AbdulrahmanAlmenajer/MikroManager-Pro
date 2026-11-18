import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/utils/audit_logger.dart';
import '../../../core/utils/pdf_generator_helper.dart';
import '../../routers/domain/active_router_provider.dart';
import '../../routers/domain/routers_notifier.dart';
import '../data/vouchers_repository.dart';
import 'voucher_generator_engine.dart';

final vouchersRepositoryProvider = Provider<VouchersRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final logger = ref.watch(auditLoggerProvider);
  return VouchersRepository(db, logger);
});

final voucherBatchesStreamProvider =
    StreamProvider<List<VoucherBatchesTableData>>((ref) {
  final repo = ref.watch(vouchersRepositoryProvider);
  return repo.watchBatches();
});

class VoucherGeneratorState {
  final List<VoucherCardData> currentVouchers;
  final bool isGenerating;
  final bool isUploading;
  final int uploadedCount;
  final int totalCount;
  final double uploadProgress;
  final bool isCancelled;
  final String? message;
  final String? errorMessage;

  const VoucherGeneratorState({
    this.currentVouchers = const [],
    this.isGenerating = false,
    this.isUploading = false,
    this.uploadedCount = 0,
    this.totalCount = 0,
    this.uploadProgress = 0.0,
    this.isCancelled = false,
    this.message,
    this.errorMessage,
  });

  VoucherGeneratorState copyWith({
    List<VoucherCardData>? currentVouchers,
    bool? isGenerating,
    bool? isUploading,
    int? uploadedCount,
    int? totalCount,
    double? uploadProgress,
    bool? isCancelled,
    String? message,
    String? errorMessage,
  }) {
    return VoucherGeneratorState(
      currentVouchers: currentVouchers ?? this.currentVouchers,
      isGenerating: isGenerating ?? this.isGenerating,
      isUploading: isUploading ?? this.isUploading,
      uploadedCount: uploadedCount ?? this.uploadedCount,
      totalCount: totalCount ?? this.totalCount,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isCancelled: isCancelled ?? this.isCancelled,
      message: message,
      errorMessage: errorMessage,
    );
  }
}

class VouchersNotifier extends StateNotifier<VoucherGeneratorState> {
  final Ref _ref;
  final VouchersRepository _repo;
  bool _isCancelRequested = false;

  VouchersNotifier(this._ref, this._repo)
      : super(const VoucherGeneratorState());

  void setVouchersForPreview(List<VoucherCardData> vouchers) {
    state = state.copyWith(currentVouchers: vouchers);
  }

  void loadFromBatch(VoucherBatchesTableData batch) {
    try {
      final List decoded = jsonDecode(batch.vouchersJson) as List;
      final vouchers = decoded
          .map((e) =>
              VoucherCardData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      state = state.copyWith(currentVouchers: vouchers);
    } catch (_) {}
  }

  void cancelGeneration() {
    _isCancelRequested = true;
    state = state.copyWith(isCancelled: true);
  }

  Future<bool> generateAndSave({
    required int quantity,
    required String profile,
    required double price,
    String prefix = '',
    int codeLength = 8,
    VoucherCodeType codeType = VoucherCodeType.numeric,
    CredentialMode credentialMode = CredentialMode.identical,
    bool sameUserAndPass = true,
    int passwordLength = 4,
    VoucherCodeType passwordCodeType = VoucherCodeType.numeric,
    bool uploadToRouter = true,
    bool isUserManager = false,
    String? networkName,
    String? notes,
  }) async {
    _isCancelRequested = false;
    state = state.copyWith(
      isGenerating: true,
      isUploading: false,
      uploadedCount: 0,
      totalCount: quantity,
      uploadProgress: 0.0,
      isCancelled: false,
      message: null,
      errorMessage: null,
    );

    try {
      // 1. Generate unique vouchers locally
      final vouchers = VoucherGeneratorEngine.generateBatch(
        quantity: quantity,
        profile: profile,
        price: price,
        prefix: prefix,
        codeLength: codeLength,
        codeType: codeType,
        credentialMode: credentialMode,
        passwordLength: passwordLength,
        passwordCodeType: passwordCodeType,
        networkName: networkName,
      );

      // 2. Upload to Router in chunks of 50 with cancel check and progress
      int uploadedCount = 0;
      if (uploadToRouter) {
        state = state.copyWith(isUploading: true);
        final adapter = await _ref.read(activeAdapterProvider.future);
        if (adapter != null) {
          uploadedCount = await _repo.uploadToRouter(
            adapter: adapter,
            vouchers: vouchers,
            isUserManager: isUserManager,
            onProgress: (current, total) {
              if (mounted) {
                state = state.copyWith(
                  uploadedCount: current,
                  totalCount: total,
                  uploadProgress: total > 0 ? (current / total) : 0.0,
                );
              }
            },
            isCancelled: () => _isCancelRequested,
          );
        }
      }

      // 3. Save batch to Drift local database
      final activeRouter = _ref.read(routersControllerProvider).activeRouter;
      final routerId = activeRouter?.id ?? 1;

      await _repo.saveBatch(
        routerId: routerId,
        profileName: profile,
        quantity: vouchers.length,
        prefix: prefix,
        codeLength: codeLength,
        vouchers: vouchers,
        unitPrice: price,
        notes: notes,
      );

      // Record card_events in Drift
      final db = _ref.read(databaseProvider);
      await db.into(db.cardEventsTable).insert(
            CardEventsTableCompanion.insert(
              connectionId: routerId,
              type: 'generated',
              count: vouchers.length,
              profile: profile,
            ),
          );

      state = state.copyWith(
        currentVouchers: vouchers,
        isGenerating: false,
        isUploading: false,
        message: _isCancelRequested
            ? 'تم إيقاف الرفع جزئياً بعد رفع $uploadedCount كرت وحفظ الدفعة محلياً.'
            : (uploadToRouter
                ? 'تم توليد $quantity كرت ورفع $uploadedCount كرت إلى الراوتر بنجاح!'
                : 'تم توليد $quantity كرت وحفظها محلياً بنجاح!'),
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        isUploading: false,
        errorMessage: 'حدث خطأ أثناء التوليد: $e',
      );
      return false;
    }
  }

  Future<bool> deleteBatch(int id) async {
    return await _repo.deleteBatch(id);
  }
}

final vouchersControllerProvider =
    StateNotifierProvider<VouchersNotifier, VoucherGeneratorState>((ref) {
  final repo = ref.watch(vouchersRepositoryProvider);
  return VouchersNotifier(ref, repo);
});
