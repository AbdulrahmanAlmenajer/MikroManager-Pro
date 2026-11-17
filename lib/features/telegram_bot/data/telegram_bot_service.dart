import 'package:dio/dio.dart';

class TelegramBotService {
  final Dio _dio;

  TelegramBotService([Dio? dio]) : _dio = dio ?? Dio();

  Future<bool> sendMessage({
    required String botToken,
    required String chatId,
    required String message,
  }) async {
    try {
      final url = 'https://api.telegram.org/bot$botToken/sendMessage';
      final response = await _dio.post(
        url,
        data: {
          'chat_id': chatId,
          'text': message,
          'parse_mode': 'Markdown',
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      return response.statusCode == 200 && response.data['ok'] == true;
    } catch (_) {
      return false;
    }
  }
}
