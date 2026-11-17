import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/security/secure_storage_service.dart';
import '../data/telegram_bot_service.dart';

class TelegramBotState {
  final String botToken;
  final String chatId;
  final bool alertRouterDown;
  final bool alertHighCpu;
  final bool alertVoucherThreshold;
  final bool isSending;
  final bool? lastSendSuccess;

  const TelegramBotState({
    this.botToken = '',
    this.chatId = '',
    this.alertRouterDown = true,
    this.alertHighCpu = true,
    this.alertVoucherThreshold = true,
    this.isSending = false,
    this.lastSendSuccess,
  });

  TelegramBotState copyWith({
    String? botToken,
    String? chatId,
    bool? alertRouterDown,
    bool? alertHighCpu,
    bool? alertVoucherThreshold,
    bool? isSending,
    bool? lastSendSuccess,
  }) {
    return TelegramBotState(
      botToken: botToken ?? this.botToken,
      chatId: chatId ?? this.chatId,
      alertRouterDown: alertRouterDown ?? this.alertRouterDown,
      alertHighCpu: alertHighCpu ?? this.alertHighCpu,
      alertVoucherThreshold: alertVoucherThreshold ?? this.alertVoucherThreshold,
      isSending: isSending ?? this.isSending,
      lastSendSuccess: lastSendSuccess,
    );
  }
}

class TelegramBotNotifier extends StateNotifier<TelegramBotState> {
  final TelegramBotService _service;

  TelegramBotNotifier(this._service) : super(const TelegramBotState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final token = await SecureStorageService.getTelegramBotToken() ?? '';
    final chat = await SecureStorageService.getTelegramChatId() ?? '';
    state = state.copyWith(botToken: token, chatId: chat);
  }

  Future<void> saveSettings({
    required String botToken,
    required String chatId,
    required bool alertRouterDown,
    required bool alertHighCpu,
    required bool alertVoucherThreshold,
  }) async {
    await SecureStorageService.saveTelegramConfig(token: botToken, chatId: chatId);
    state = state.copyWith(
      botToken: botToken,
      chatId: chatId,
      alertRouterDown: alertRouterDown,
      alertHighCpu: alertHighCpu,
      alertVoucherThreshold: alertVoucherThreshold,
    );
  }

  Future<bool> sendTestMessage() async {
    if (state.botToken.isEmpty || state.chatId.isEmpty) return false;

    state = state.copyWith(isSending: true, lastSendSuccess: null);

    const testMessage = '🚀 *MikroManager Pro*\n\n'
        'تم الاتصال بنجاح مع بوت تيليجرام!\n'
        'جاهز لإرسال تنبيهات المراقبة وحالة الراوتر والكروت.';

    final success = await _service.sendMessage(
      botToken: state.botToken,
      chatId: state.chatId,
      message: testMessage,
    );

    state = state.copyWith(isSending: false, lastSendSuccess: success);
    return success;
  }
}

final telegramBotServiceProvider = Provider<TelegramBotService>((ref) {
  return TelegramBotService();
});

final telegramBotControllerProvider =
    StateNotifierProvider<TelegramBotNotifier, TelegramBotState>((ref) {
  final service = ref.watch(telegramBotServiceProvider);
  return TelegramBotNotifier(service);
});
