import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/session/session_controller.dart';
import '../data/subscribers_repository.dart';
import 'subscribers_notifier.dart';

class CardDiagnosisState {
  final String cardName;
  final bool isAnalyzing;
  final CardDiagnosisResult? result;
  final String? errorMessage;
  final bool isActionInProgress;

  const CardDiagnosisState({
    this.cardName = '',
    this.isAnalyzing = false,
    this.result,
    this.errorMessage,
    this.isActionInProgress = false,
  });

  CardDiagnosisState copyWith({
    String? cardName,
    bool? isAnalyzing,
    CardDiagnosisResult? result,
    String? errorMessage,
    bool? isActionInProgress,
  }) {
    return CardDiagnosisState(
      cardName: cardName ?? this.cardName,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      result: result ?? this.result,
      errorMessage: errorMessage,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
    );
  }
}

class CardDiagnosisNotifier extends StateNotifier<CardDiagnosisState> {
  final Ref _ref;
  final SubscribersRepository _repo;

  CardDiagnosisNotifier(this._ref, this._repo) : super(const CardDiagnosisState());

  Future<void> diagnose(String cardName) async {
    if (cardName.trim().isEmpty) return;

    state = state.copyWith(
      cardName: cardName.trim(),
      isAnalyzing: true,
      errorMessage: null,
      result: null,
    );

    try {
      final session = _ref.read(sessionControllerProvider).session;
      if (session == null) {
        state = state.copyWith(isAnalyzing: false, errorMessage: 'لا توجد جلسة راوتر نشطة');
        return;
      }

      final res = await _repo.diagnoseCard(session.adapter, cardName.trim());
      state = state.copyWith(isAnalyzing: false, result: res);
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        errorMessage: 'حدث خطأ أثناء فحص الكرت: ${e.toString()}',
      );
    }
  }

  Future<bool> reEnableCard() async {
    final sub = state.result?.subscriber;
    final session = _ref.read(sessionControllerProvider).session;
    if (sub == null || session == null) return false;

    state = state.copyWith(isActionInProgress: true);
    try {
      final success = await _repo.toggleSubscriberStatus(session.adapter, sub, true);
      if (success) {
        await diagnose(state.cardName);
      }
      return success;
    } finally {
      state = state.copyWith(isActionInProgress: false);
    }
  }

  Future<bool> resetMac() async {
    final session = _ref.read(sessionControllerProvider).session;
    if (session == null) return false;

    state = state.copyWith(isActionInProgress: true);
    try {
      final success = await _repo.resetMacBinding(session.adapter, state.cardName);
      if (success) {
        await diagnose(state.cardName);
      }
      return success;
    } finally {
      state = state.copyWith(isActionInProgress: false);
    }
  }

  Future<bool> kickSession() async {
    final session = _ref.read(sessionControllerProvider).session;
    if (session == null) return false;

    state = state.copyWith(isActionInProgress: true);
    try {
      final success = await _repo.kickHotspotActive(session.adapter, state.cardName);
      if (success) {
        await diagnose(state.cardName);
      }
      return success;
    } finally {
      state = state.copyWith(isActionInProgress: false);
    }
  }
}

final cardDiagnosisProvider =
    StateNotifierProvider.autoDispose<CardDiagnosisNotifier, CardDiagnosisState>((ref) {
  final repo = ref.watch(subscribersRepositoryProvider);
  return CardDiagnosisNotifier(ref, repo);
});
