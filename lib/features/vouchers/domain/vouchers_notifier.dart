import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/tasks/task_runner.dart';
import '../../../core/utils/audit_logger.dart';
import '../../../core/utils/pdf_generator_helper.dart';
import '../../routers/domain/active_router_provider.dart';
import '../../routers/domain/routers_notifier.dart';
import '../data/vouchers_repository.dart';
import 'unified_card_model.dart';
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

class DraftBatchParams {
  final CardSystemType systemType;
  final bool isUserManager;
  final String profile;
  final double price;
  final String prefix;
  final int codeLength;
  final bool enableSerial;
  final String serialPrefix;
  final int serialStart;
  final int serialPadding;
  final String? networkName;
  final String? notes;

  const DraftBatchParams({
    required this.systemType,
    required this.isUserManager,
    required this.profile,
    required this.price,
    this.prefix = '',
    this.codeLength = 8,
    this.enableSerial = false,
    this.serialPrefix = 'SN-',
    this.serialStart = 1,
    this.serialPadding = 4,
    this.networkName,
    this.notes,
  });
}

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
  final bool isDraft; // For pre-commit preview
  final DraftBatchParams? draftParams;

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
    this.isDraft = false,
    this.draftParams,
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
    bool? isDraft,
    DraftBatchParams? draftParams,
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
      isDraft: isDraft ?? this.isDraft,
      draftParams: draftParams ?? this.draftParams,
    );
  }
}

class VouchersNotifier extends StateNotifier<VoucherGeneratorState> {
  final Ref _ref;
  final VouchersRepository _repo;
  bool _isCancelRequested = false;

  VouchersNotifier(this._ref, this._repo)
      : super(const VoucherGeneratorState());

  void setVouchersForPreview(List<VoucherCardData> vouchers, {bool isDraft = false}) {
    state = state.copyWith(currentVouchers: vouchers, isDraft: isDraft);
  }

  void loadFromBatch(VoucherBatchesTableData batch) {
    try {
      final List decoded = jsonDecode(batch.vouchersJson) as List;
      final vouchers = decoded
          .map((e) =>
              VoucherCardData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      state = state.copyWith(currentVouchers: vouchers, isDraft: false);
    } on FormatException catch (e) {
      state = state.copyWith(
        errorMessage: 'تعذّر قراءة بيانات الدفعة (JSON خاطئ): ${e.message}',
      );
    } on TypeError catch (e) {
      state = state.copyWith(
        errorMessage: 'تنسيق بيانات الدفعة غير متوقع: ${e.toString()}',
      );
    }
  }

  void cancelGeneration() {
    _isCancelRequested = true;
    state = state.copyWith(isCancelled: true);
  }

  /// Generate draft vouchers locally for preview before committing to router
  List<VoucherCardData> generateDraftVouchers({
    required int quantity,
    required String profile,
    required double price,
    String prefix = '',
    int codeLength = 8,
    VoucherCodeType codeType = VoucherCodeType.numeric,
    CredentialMode credentialMode = CredentialMode.identical,
    int passwordLength = 4,
    VoucherCodeType passwordCodeType = VoucherCodeType.numeric,
    String? validity,
    String? networkName,
    bool enableSerial = false,
    String serialPrefix = 'SN-',
    int serialStart = 1,
    int serialPadding = 4,
    bool isUserManager = false,
    CardSystemType? systemType,
    String? notes,
  }) {
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
      validity: validity,
      networkName: networkName,
      enableSerial: enableSerial,
      serialPrefix: serialPrefix,
      serialStart: serialStart,
      serialPadding: serialPadding,
    );

    final effectiveSystemType = systemType ??
        (isUserManager ? CardSystemType.usermanV7 : CardSystemType.hotspot);

    final params = DraftBatchParams(
      systemType: effectiveSystemType,
      isUserManager: isUserManager,
      profile: profile,
      price: price,
      prefix: prefix,
      codeLength: codeLength,
      enableSerial: enableSerial,
      serialPrefix: serialPrefix,
      serialStart: serialStart,
      serialPadding: serialPadding,
      networkName: networkName,
      notes: notes,
    );

    state = state.copyWith(
      currentVouchers: vouchers,
      isDraft: true,
      draftParams: params,
      message: 'تم إنشاء معاينة الدفعة (${vouchers.length} كرت). يمكنك المعاينة والطباعة الآن قبل الاعتماد.',
      errorMessage: null,
    );

    return vouchers;
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
    CardSystemType? systemType,
    String? networkName,
    bool enableSerial = false,
    String serialPrefix = 'SN-',
    int serialStart = 1,
    int serialPadding = 4,
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
      isDraft: false,
      message: null,
      errorMessage: null,
    );

    try {
      final effectiveSystemType = systemType ??
          (isUserManager ? CardSystemType.usermanV7 : CardSystemType.hotspot);

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
        enableSerial: enableSerial,
        serialPrefix: serialPrefix,
        serialStart: serialStart,
        serialPadding: serialPadding,
      );

      final serialEnd =
          enableSerial ? (serialStart + quantity - 1) : null;

      // 2. Upload to Router in chunks of 50 with cancel check and progress
      int uploadedCount = 0;
      final activeRouter = _ref.read(routersControllerProvider).activeRouter;
      final routerId = activeRouter?.id ?? 1;
      final taskRunner = _ref.read(taskRunnerProvider);
      int? checkpointId;

      if (uploadToRouter) {
        state = state.copyWith(isUploading: true);
        final adapter = await _ref.read(activeAdapterProvider.future);
        if (adapter != null) {
          try {
            checkpointId = await taskRunner.createCheckpoint(
              taskId: 'voucher_upload_${DateTime.now().millisecondsSinceEpoch}',
              connectionId: routerId,
              taskType: 'voucher_upload',
              totalItems: quantity,
              payload: {
                'profile': profile,
                'price': price,
                'quantity': quantity,
                'isUserManager': isUserManager,
                'systemType': effectiveSystemType.name,
              },
            );
          } on Object catch (e) {
            _ref.read(auditLoggerProvider).log(
                  action: 'checkpoint_create_failed',
                  entityType: 'task_runner',
                  description: 'فشل إنشاء نقطة فحص للمهمة: $e',
                );
          }

          try {
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
                if (checkpointId != null) {
                  taskRunner.updateProgress(
                    checkpointId: checkpointId,
                    processed: current,
                    succeeded: current,
                    failed: 0,
                    status: _isCancelRequested ? 'failed' : 'running',
                  );
                }
              },
              isCancelled: () => _isCancelRequested,
            );

            if (checkpointId != null) {
              if (_isCancelRequested) {
                await taskRunner.failCheckpoint(
                  checkpointId,
                  'تم إيقاف عملية الرفع يدوياً بواسطة المستخدم',
                );
              } else {
                await taskRunner.completeCheckpoint(checkpointId);
              }
            }
          } catch (uploadError) {
            if (checkpointId != null) {
              await taskRunner.failCheckpoint(
                checkpointId,
                uploadError.toString(),
              );
            }
            rethrow;
          }
        }
      }

      // 3. Save batch to Drift local database
      await _repo.saveBatch(
        routerId: routerId,
        profileName: profile,
        quantity: vouchers.length,
        prefix: prefix,
        codeLength: codeLength,
        vouchers: vouchers,
        unitPrice: price,
        systemType: effectiveSystemType.name,
        serialPrefix: enableSerial ? serialPrefix : null,
        serialStart: enableSerial ? serialStart : null,
        serialPadding: enableSerial ? serialPadding : null,
        serialEnd: serialEnd,
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

  /// Commit current draft vouchers and upload them to the router
  Future<bool> commitDraftBatch({
    void Function(int current, int total)? onProgress,
  }) async {
    if (state.currentVouchers.isEmpty || !state.isDraft) {
      state = state.copyWith(errorMessage: 'لا توجد مسودة كروت جاهزة للاعتماد');
      return false;
    }

    final params = state.draftParams;
    final isUserManager = params?.isUserManager ?? false;
    final effectiveSystemType = params?.systemType ??
        (isUserManager ? CardSystemType.usermanV7 : CardSystemType.hotspot);
    final profile = params?.profile ?? state.currentVouchers.first.profile;
    final price = params?.price ?? state.currentVouchers.first.price;
    final prefix = params?.prefix ?? '';
    final codeLength = params?.codeLength ?? 8;
    final enableSerial = params?.enableSerial ?? false;
    final serialPrefix = params?.serialPrefix ?? 'SN-';
    final serialStart = params?.serialStart ?? 1;
    final serialPadding = params?.serialPadding ?? 4;
    final serialEnd = enableSerial
        ? (serialStart + state.currentVouchers.length - 1)
        : null;
    final notes = params?.notes;

    _isCancelRequested = false;
    state = state.copyWith(
      isUploading: true,
      uploadedCount: 0,
      totalCount: state.currentVouchers.length,
      uploadProgress: 0.0,
      isCancelled: false,
      message: null,
      errorMessage: null,
    );

    try {
      final activeRouter = _ref.read(routersControllerProvider).activeRouter;
      final routerId = activeRouter?.id ?? 1;
      final adapter = await _ref.read(activeAdapterProvider.future);

      if (adapter == null) {
        throw Exception('الراوتر غير متصل. يرجى التحقق من الاتصال بالراوتر أولاً.');
      }

      // Check collision
      final collisions = await _repo.checkUsernameCollisions(
        adapter: adapter,
        usernames: state.currentVouchers.map((v) => v.username).toList(),
        isUserManager: isUserManager,
      );

      if (collisions.isNotEmpty) {
        state = state.copyWith(
          isUploading: false,
          errorMessage:
              'تم اكتشاف تكرار في أسماء المستخدمين على الراوتر (${collisions.take(3).join(', ')}${collisions.length > 3 ? '...' : ''}). يرجى العودة وإعادة التوليد ببادئة مختلفة.',
        );
        return false;
      }

      // Upload to router
      final taskRunner = _ref.read(taskRunnerProvider);
      int? checkpointId;
      try {
        checkpointId = await taskRunner.createCheckpoint(
          taskId: 'voucher_commit_${DateTime.now().millisecondsSinceEpoch}',
          connectionId: routerId,
          taskType: 'voucher_upload',
          totalItems: state.currentVouchers.length,
          payload: {
            'profile': profile,
            'price': price,
            'quantity': state.currentVouchers.length,
            'isUserManager': isUserManager,
            'systemType': effectiveSystemType.name,
          },
        );
      } catch (_) {}

      final uploaded = await _repo.uploadToRouter(
        adapter: adapter,
        vouchers: state.currentVouchers,
        isUserManager: isUserManager,
        onProgress: (current, total) {
          onProgress?.call(current, total);
          if (mounted) {
            state = state.copyWith(
              uploadedCount: current,
              totalCount: total,
              uploadProgress: total > 0 ? (current / total) : 0.0,
            );
          }
          if (checkpointId != null) {
            taskRunner.updateProgress(
              checkpointId: checkpointId,
              processed: current,
              succeeded: current,
              failed: 0,
              status: _isCancelRequested ? 'failed' : 'running',
            );
          }
        },
        isCancelled: () => _isCancelRequested,
      );

      if (checkpointId != null) {
        if (_isCancelRequested) {
          await taskRunner.failCheckpoint(checkpointId, 'تم الإلغاء يدوياً');
        } else {
          await taskRunner.completeCheckpoint(checkpointId);
        }
      }

      // Save batch to Drift local database
      await _repo.saveBatch(
        routerId: routerId,
        profileName: profile,
        quantity: state.currentVouchers.length,
        prefix: prefix,
        codeLength: codeLength,
        vouchers: state.currentVouchers,
        unitPrice: price,
        systemType: effectiveSystemType.name,
        serialPrefix: enableSerial ? serialPrefix : null,
        serialStart: enableSerial ? serialStart : null,
        serialPadding: enableSerial ? serialPadding : null,
        serialEnd: serialEnd,
        notes: notes,
      );

      // Record card event
      final db = _ref.read(databaseProvider);
      await db.into(db.cardEventsTable).insert(
            CardEventsTableCompanion.insert(
              connectionId: routerId,
              type: 'generated',
              count: state.currentVouchers.length,
              profile: profile,
            ),
          );

      state = state.copyWith(
        isUploading: false,
        isDraft: false,
        draftParams: null,
        message: 'تم اعتماد الدفعة ورفع $uploaded كرت إلى الراوتر بنجاح!',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: 'فشل اعتماد ورفع الكروت: $e',
      );
      return false;
    }
  }

  void discardDraft() {
    state = state.copyWith(
      currentVouchers: [],
      isDraft: false,
      draftParams: null,
      message: null,
      errorMessage: null,
    );
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
