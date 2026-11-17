import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _routerPasswordPrefix = 'router_pass_';
  static const String _selectedRouterKey = 'selected_router_id';
  static const String _telegramBotTokenKey = 'telegram_bot_token';
  static const String _telegramChatIdKey = 'telegram_chat_id';

  // Router password management
  static Future<void> saveRouterPassword(int routerId, String password) async {
    await _storage.write(key: '$_routerPasswordPrefix$routerId', value: password);
  }

  static Future<String?> getRouterPassword(int routerId) async {
    return await _storage.read(key: '$_routerPasswordPrefix$routerId');
  }

  static Future<void> deleteRouterPassword(int routerId) async {
    await _storage.delete(key: '$_routerPasswordPrefix$routerId');
  }

  // Selected router
  static Future<void> setSelectedRouter(String routerId) async {
    await _storage.write(key: _selectedRouterKey, value: routerId);
  }

  static Future<String?> getSelectedRouter() async {
    return await _storage.read(key: _selectedRouterKey);
  }

  // Telegram Bot
  static Future<void> saveTelegramConfig({required String token, required String chatId}) async {
    await saveTelegramBotToken(token);
    await saveTelegramChatId(chatId);
  }

  static Future<void> saveTelegramBotToken(String token) async {
    await _storage.write(key: _telegramBotTokenKey, value: token);
  }

  static Future<String?> getTelegramBotToken() async {
    return await _storage.read(key: _telegramBotTokenKey);
  }

  static Future<void> saveTelegramChatId(String chatId) async {
    await _storage.write(key: _telegramChatIdKey, value: chatId);
  }

  static Future<String?> getTelegramChatId() async {
    return await _storage.read(key: _telegramChatIdKey);
  }

  // Clear all sensitive data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
