import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/network/routeros_adapter.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../../core/session/session_controller.dart';
import '../data/alerts_repository.dart';
import '../data/telegram_bot_service.dart';

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AlertsRepository(db);
});

class TelegramBotState {
  final String botToken;
  final String chatId;
  final bool alertRouterDown;
  final bool alertHighCpu;
  final bool alertVoucherThreshold;
  final bool alertRogueDhcp;
  final bool isSending;
  final bool isScanningDhcp;
  final bool? lastSendSuccess;
  final List<RogueDhcpAlert> rogueAlerts;
  final List<TrustedDhcpServersTableData> trustedServers;
  final QuietHoursTableData? quietHours;

  const TelegramBotState({
    this.botToken = '',
    this.chatId = '',
    this.alertRouterDown = true,
    this.alertHighCpu = true,
    this.alertVoucherThreshold = true,
    this.alertRogueDhcp = true,
    this.isSending = false,
    this.isScanningDhcp = false,
    this.lastSendSuccess,
    this.rogueAlerts = const [],
    this.trustedServers = const [],
    this.quietHours,
  });

  TelegramBotState copyWith({
    String? botToken,
    String? chatId,
    bool? alertRouterDown,
    bool? alertHighCpu,
    bool? alertVoucherThreshold,
    bool? alertRogueDhcp,
    bool? isSending,
    bool? isScanningDhcp,
    bool? lastSendSuccess,
    List<RogueDhcpAlert>? rogueAlerts,
    List<TrustedDhcpServersTableData>? trustedServers,
    QuietHoursTableData? quietHours,
  }) {
    return TelegramBotState(
      botToken: botToken ?? this.botToken,
      chatId: chatId ?? this.chatId,
      alertRouterDown: alertRouterDown ?? this.alertRouterDown,
      alertHighCpu: alertHighCpu ?? this.alertHighCpu,
      alertVoucherThreshold: alertVoucherThreshold ?? this.alertVoucherThreshold,
      alertRogueDhcp: alertRogueDhcp ?? this.alertRogueDhcp,
      isSending: isSending ?? this.isSending,
      isScanningDhcp: isScanningDhcp ?? this.isScanningDhcp,
      lastSendSuccess: lastSendSuccess,
      rogueAlerts: rogueAlerts ?? this.rogueAlerts,
      trustedServers: trustedServers ?? this.trustedServers,
      quietHours: quietHours ?? this.quietHours,
    );
  }
}

class TelegramBotNotifier extends StateNotifier<TelegramBotState> {
  final TelegramBotService _service;
  final AlertsRepository _alertsRepo;

  TelegramBotNotifier(this._service, this._alertsRepo) : super(const TelegramBotState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final token = await SecureStorageService.getTelegramBotToken() ?? '';
    final chat = await SecureStorageService.getTelegramChatId() ?? '';
    state = state.copyWith(botToken: token, chatId: chat);
  }

  Future<void> loadConnectionData(int connectionId) async {
    final trusted = await _alertsRepo.getTrustedDhcpServers(connectionId);
    final quiet = await _alertsRepo.getQuietHours(connectionId);
    state = state.copyWith(trustedServers: trusted, quietHours: quiet);
  }

  Future<void> saveSettings({
    required String botToken,
    required String chatId,
    required bool alertRouterDown,
    required bool alertHighCpu,
    required bool alertVoucherThreshold,
    required bool alertRogueDhcp,
  }) async {
    await SecureStorageService.saveTelegramConfig(token: botToken, chatId: chatId);
    state = state.copyWith(
      botToken: botToken,
      chatId: chatId,
      alertRouterDown: alertRouterDown,
      alertHighCpu: alertHighCpu,
      alertVoucherThreshold: alertVoucherThreshold,
      alertRogueDhcp: alertRogueDhcp,
    );
  }

  Future<bool> sendTestMessage() async {
    if (state.botToken.isEmpty || state.chatId.isEmpty) return false;

    state = state.copyWith(isSending: true, lastSendSuccess: null);

    const testMessage = '🚀 *MikroManager Pro*\n\n'
        'تم الاتصال بنجاح مع بوت تيليجرام!\n'
        'جاهز لإرسال تنبيهات المراقبة وسقوط الراوتر وخوادم DHCP الدخيلة.';

    final success = await _service.sendMessage(
      botToken: state.botToken,
      chatId: state.chatId,
      message: testMessage,
    );

    state = state.copyWith(isSending: false, lastSendSuccess: success);
    return success;
  }

  // =========================================================================
  // Rogue DHCP Scanning & Management
  // =========================================================================

  Future<void> scanRogueDhcp(RouterOsAdapter adapter, int connectionId) async {
    state = state.copyWith(isScanningDhcp: true);
    try {
      final results = await _alertsRepo.scanForRogueDhcp(
        connectionId: connectionId,
        adapter: adapter,
      );

      // Check if any rogue server exists and send urgent telegram alert
      final rogue = results.where((r) => !r.isTrusted).toList();
      if (rogue.isNotEmpty && state.alertRogueDhcp) {
        final alertMsg = '🚨 *تحذير أمني عاجل: تم اكتشاف خادم DHCP دخيل!*\n\n'
            'الـ IP المكتشف: `${rogue.first.serverIp}`\n'
            'الواجهة: `${rogue.first.interface}`\n'
            'يرجى فحص الشبكة فوراً لمنع انقطاع خدمة المشتركين.';
        await _service.sendMessage(
          botToken: state.botToken,
          chatId: state.chatId,
          message: alertMsg,
        );
      }

      state = state.copyWith(
        rogueAlerts: results,
        isScanningDhcp: false,
      );
    } catch (_) {
      state = state.copyWith(isScanningDhcp: false);
    }
  }

  Future<void> addTrustedServer(int connectionId, String ip, String iface) async {
    await _alertsRepo.addTrustedDhcpServer(
      connectionId: connectionId,
      serverIp: ip,
      interface: iface,
    );
    await loadConnectionData(connectionId);
  }

  Future<void> removeTrustedServer(int id, int connectionId) async {
    await _alertsRepo.removeTrustedDhcpServer(id);
    await loadConnectionData(connectionId);
  }

  // =========================================================================
  // Quiet Hours Management
  // =========================================================================

  Future<void> setQuietHours({
    required int connectionId,
    required int startMinute,
    required int endMinute,
    String days = '1,2,3,4,5,6,7',
  }) async {
    await _alertsRepo.setQuietHours(
      connectionId: connectionId,
      startMinute: startMinute,
      endMinute: endMinute,
      days: days,
    );
    await loadConnectionData(connectionId);
  }

  Future<void> muteQuietHoursUntil(int connectionId, DateTime muteUntil) async {
    final current = state.quietHours;
    await _alertsRepo.setQuietHours(
      connectionId: connectionId,
      startMinute: current?.startMinute ?? 0,
      endMinute: current?.endMinute ?? 360,
      days: current?.days ?? '1,2,3,4,5,6,7',
      muteUntil: muteUntil,
    );
    await loadConnectionData(connectionId);
  }
}

final telegramBotServiceProvider = Provider<TelegramBotService>((ref) {
  return TelegramBotService();
});

final telegramBotControllerProvider =
    StateNotifierProvider<TelegramBotNotifier, TelegramBotState>((ref) {
  final service = ref.watch(telegramBotServiceProvider);
  final alertsRepo = ref.watch(alertsRepositoryProvider);
  final notifier = TelegramBotNotifier(service, alertsRepo);

  final session = ref.watch(sessionControllerProvider).session;
  if (session != null) {
    notifier.loadConnectionData(session.connectionId);
  }

  return notifier;
});
