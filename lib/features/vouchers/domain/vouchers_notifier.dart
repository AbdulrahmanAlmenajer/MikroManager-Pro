import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/utils/pdf_generator_helper.dart';
import '../../hotspot/domain/hotspot_notifier.dart';
import '../../routers/domain/active_router_provider.dart';
import '../../routers/domain/routers_notifier.dart';
import '../data/vouchers_repository.dart';
import 'voucher_generator_engine.dart';

final vouchersRepositoryProvider = Provider<VouchersRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final logger = ref.watch(auditLoggerProvider);
  return VouchersRepository(db, logger);
});

final voucherBatchesStreamProvider = StreamProvider<List<VoucherBatchesTableData>>((ref) {
  final repo = ref.watch(vouchersRepositoryProvider);
  return repo.watchBatches();
});

class VoucherGeneratorState {
  final List<VoucherCardData> currentVouchers;
  final bool isGenerating;
  final bool isUploading;
  final String? message;
  final String? errorMessage;

  VoucherGeneratorState({
    this.currentVouchers = const [],
    this.isGenerating = false,
    this.isUploading = false,
    this.message,
    this.errorMessage,
  });

  VoucherGeneratorState copyWith({
    List<VoucherCardData>? currentVouchers,
    bool? isGenerating,
    bool? isUploading,
    String? message,
    String? errorMessage,
  }) {
    return VoucherGeneratorState(
      currentVouchers: currentVouchers ?? this.currentVouchers,
      isGenerating: isGenerating ?? this.isGenerating,
      isUploading: isUploading ?? this.isUploading,
      message: message,
      errorMessage: errorMessage,
    );
  }
}

class VouchersNotifier extends StateNotifier<VoucherGeneratorState> {
  final Ref _ref;
  final VouchersRepository _repo;

  VouchersNotifier(this._ref, this._repo) : super(VoucherGeneratorState());

  void setVouchersForPreview(List<VoucherCardData> vouchers) {
    state = state.copyWith(currentVouchers: vouchers);
  }

  void loadFromBatch(VoucherBatchesTableData batch) {
    try {
      final List decoded = jsonDecode(batch.vouchersJson) as List;
      final vouchers = decoded.map((e) => VoucherCardData.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      state = state.copyWith(currentVouchers: vouchers);
    } catch (_) {}
  }

  Future<bool> generateAndSave({
    required int quantity,
    required String profile,
    required double price,
    String prefix = '',
    int codeLength = 8,
    VoucherCodeType codeType = VoucherCodeType.numeric,
    bool sameUserAndPass = true,
    bool uploadToRouter = true,
    bool isUserManager = false,
    String? networkName,
    String? notes,
  }) async {
    state = state.copyWith(isGenerating: true, message: null, errorMessage: null);

    try {
      // 1. Generate local unique vouchers
      final vouchers = VoucherGeneratorEngine.generateBatch(
        quantity: quantity,
        profile: profile,
        price: price,
        prefix: prefix,
        codeLength: codeLength,
        codeType: codeType,
        sameUserAndPass: sameUserAndPass,
        networkName: networkName,
      );

      // 2. Upload to Router if selected
      int uploadedCount = 0;
      if (uploadToRouter) {
        state = state.copyWith(isUploading: true);
        final adapter = await _ref.read(activeAdapterProvider.future);
        if (adapter != null) {
          uploadedCount = await _repo.uploadToRouter(
            adapter: adapter,
            vouchers: vouchers,
            isUserManager: isUserManager,
          );
        }
      }

      // 3. Save batch to Drift local database
      final activeRouter = _ref.read(routersControllerProvider).activeRouter;
      final routerId = activeRouter?.id ?? 1;

      await _repo.saveBatch(
        routerId: routerId,
        profileName: profile,
        quantity: quantity,
        prefix: prefix,
        codeLength: codeLength,
        vouchers: vouchers,
        unitPrice: price,
        notes: notes,
      );

      state = state.copyWith(
        currentVouchers: vouchers,
        isGenerating: false,
        isUploading: false,
        message: uploadToRouter
            ? 'تم توليد $quantity كرت ورفع $uploadedCount كرت إلى الراوتر بنجاح!'
            : 'تم توليد $quantity كرت وحفظها محلياً بنجاح!',
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

final vouchersControllerProvider = StateNotifierProvider<VouchersNotifier, VoucherGeneratorState>((ref) {
  final repo = ref.watch(vouchersRepositoryProvider);
  return VouchersNotifier(ref, repo);
});
