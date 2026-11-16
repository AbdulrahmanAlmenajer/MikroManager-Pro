import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class RouterOsSentence {
  final String command; // !re, !done, !trap, !fatal
  final Map<String, String> attributes;

  RouterOsSentence({required this.command, required this.attributes});

  @override
  String toString() => '$command: $attributes';
}

class RouterOsResponse {
  final bool isSuccess;
  final List<Map<String, String>> data;
  final String? errorMessage;

  RouterOsResponse({
    required this.isSuccess,
    this.data = const [],
    this.errorMessage,
  });
}

class RouterOsSocketClient {
  final String host;
  final int port;
  final String username;
  final String password;
  final bool useSsl;
  final Duration timeout;

  Socket? _socket;
  bool _isConnected = false;

  RouterOsSocketClient({
    required this.host,
    this.port = 8728,
    required this.username,
    required this.password,
    this.useSsl = false,
    this.timeout = const Duration(seconds: 10),
  });

  bool get isConnected => _isConnected;

  /// Connect and authenticate with RouterOS
  Future<bool> connect() async {
    try {
      if (useSsl) {
        _socket = await SecureSocket.connect(
          host,
          port,
          timeout: timeout,
          onBadCertificate: (cert) => true, // Allow self-signed router certs
        );
      } else {
        _socket = await Socket.connect(host, port, timeout: timeout);
      }

      _isConnected = true;
      return await _login();
    } catch (e) {
      close();
      return false;
    }
  }

  /// Login protocol: supports both Post-6.43 and Legacy MD5
  Future<bool> _login() async {
    try {
      // First attempt: Post-6.43 login
      final firstAttempt = await executeSentence([
        '/login',
        '=name=$username',
        '=password=$password',
      ]);

      if (firstAttempt.isSuccess) {
        return true;
      }

      // If failed, check for legacy challenge (RouterOS < 6.43)
      final challengeAttempt = await executeSentence(['/login']);
      String? challenge;
      for (final item in challengeAttempt.data) {
        if (item.containsKey('ret')) {
          challenge = item['ret'];
          break;
        }
      }

      if (challenge != null && challenge.isNotEmpty) {
        // Compute legacy MD5 challenge
        final md5Response = _computeLegacyMd5(password, challenge);
        final legacyLogin = await executeSentence([
          '/login',
          '=name=$username',
          '=response=$md5Response',
        ]);
        return legacyLogin.isSuccess;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Legacy MD5 login challenge hash
  String _computeLegacyMd5(String password, String challengeHex) {
    // Challenge is hex string
    final List<int> challengeBytes = [];
    for (int i = 0; i < challengeHex.length; i += 2) {
      challengeBytes.add(int.parse(challengeHex.substring(i, i + 2), radix: 16));
    }

    final List<int> toHash = [0];
    toHash.addAll(utf8.encode(password));
    toHash.addAll(challengeBytes);

    final digest = md5.convert(toHash);
    return '00${digest.toString()}';
  }

  /// Execute a command sentence and return replies
  Future<RouterOsResponse> executeSentence(List<String> words) async {
    if (_socket == null) {
      return RouterOsResponse(
        isSuccess: false,
        errorMessage: 'الاتصال غير متوفر',
      );
    }

    try {
      // Send words
      for (final word in words) {
        _writeWord(word);
      }
      _writeWord(''); // Empty word terminates sentence
      await _socket!.flush();

      // Read responses until !done or !trap or !fatal
      final List<Map<String, String>> replies = [];
      String? errorMessage;
      bool isSuccess = false;

      while (true) {
        final sentence = await _readSentence();
        if (sentence == null) break;

        if (sentence.command == '!re') {
          replies.add(sentence.attributes);
        } else if (sentence.command == '!done') {
          isSuccess = true;
          if (sentence.attributes.isNotEmpty) {
            replies.add(sentence.attributes);
          }
          break;
        } else if (sentence.command == '!trap') {
          errorMessage = sentence.attributes['message'] ?? 'خطأ في تنفيذ الأمر';
          break;
        } else if (sentence.command == '!fatal') {
          errorMessage = 'خطأ جسيم في الاتصال بالراوتر';
          close();
          break;
        }
      }

      return RouterOsResponse(
        isSuccess: isSuccess,
        data: replies,
        errorMessage: errorMessage,
      );
    } catch (e) {
      return RouterOsResponse(isSuccess: false, errorMessage: e.toString());
    }
  }

  /// Encode word length according to MikroTik RouterOS API spec
  void _writeWord(String word) {
    final bytes = utf8.encode(word);
    final len = bytes.length;
    final List<int> lenBytes = [];

    if (len < 0x80) {
      lenBytes.add(len);
    } else if (len < 0x4000) {
      final val = len | 0x8000;
      lenBytes.add((val >> 8) & 0xFF);
      lenBytes.add(val & 0xFF);
    } else if (len < 0x200000) {
      final val = len | 0xC00000;
      lenBytes.add((val >> 16) & 0xFF);
      lenBytes.add((val >> 8) & 0xFF);
      lenBytes.add(val & 0xFF);
    } else if (len < 0x10000000) {
      final val = len | 0xE0000000;
      lenBytes.add((val >> 24) & 0xFF);
      lenBytes.add((val >> 16) & 0xFF);
      lenBytes.add((val >> 8) & 0xFF);
      lenBytes.add(val & 0xFF);
    } else {
      lenBytes.add(0xF0);
      lenBytes.add((len >> 24) & 0xFF);
      lenBytes.add((len >> 16) & 0xFF);
      lenBytes.add((len >> 8) & 0xFF);
      lenBytes.add(len & 0xFF);
    }

    _socket!.add(lenBytes);
    _socket!.add(bytes);
  }

  /// Read one sentence from the socket
  Future<RouterOsSentence?> _readSentence() async {
    final List<String> words = [];
    while (true) {
      final word = await _readWord();
      if (word == null) return null;
      if (word.isEmpty) break; // End of sentence
      words.add(word);
    }

    if (words.isEmpty) return null;

    final command = words.first;
    final Map<String, String> attributes = {};

    for (int i = 1; i < words.length; i++) {
      final word = words[i];
      if (word.startsWith('=')) {
        final eqIdx = word.indexOf('=', 1);
        if (eqIdx != -1) {
          final key = word.substring(1, eqIdx);
          final value = word.substring(eqIdx + 1);
          attributes[key] = value;
        } else {
          final key = word.substring(1);
          attributes[key] = '';
        }
      }
    }

    return RouterOsSentence(command: command, attributes: attributes);
  }

  final List<int> _buffer = [];

  /// Read a single word with length prefix
  Future<String?> _readWord() async {
    final len = await _readLength();
    if (len == null) return null;
    if (len == 0) return '';

    final bytes = await _readExactBytes(len);
    if (bytes == null) return null;
    return utf8.decode(bytes, allowMalformed: true);
  }

  /// Read length header bytes
  Future<int?> _readLength() async {
    final firstByte = await _readByte();
    if (firstByte == null) return null;

    if ((firstByte & 0x80) == 0x00) {
      return firstByte;
    } else if ((firstByte & 0xC0) == 0x80) {
      final b2 = await _readByte();
      if (b2 == null) return null;
      return ((firstByte & 0x3F) << 8) | b2;
    } else if ((firstByte & 0xE0) == 0xC0) {
      final b2 = await _readByte();
      final b3 = await _readByte();
      if (b2 == null || b3 == null) return null;
      return ((firstByte & 0x1F) << 16) | (b2 << 8) | b3;
    } else if ((firstByte & 0xF0) == 0xE0) {
      final b2 = await _readByte();
      final b3 = await _readByte();
      final b4 = await _readByte();
      if (b2 == null || b3 == null || b4 == null) return null;
      return ((firstByte & 0x0F) << 24) | (b2 << 16) | (b3 << 8) | b4;
    } else if (firstByte == 0xF0) {
      final b2 = await _readByte();
      final b3 = await _readByte();
      final b4 = await _readByte();
      final b5 = await _readByte();
      if (b2 == null || b3 == null || b4 == null || b5 == null) return null;
      return (b2 << 24) | (b3 << 16) | (b4 << 8) | b5;
    }
    return null;
  }

  Future<int?> _readByte() async {
    final bytes = await _readExactBytes(1);
    return bytes?.first;
  }

  Future<List<int>?> _readExactBytes(int count) async {
    while (_buffer.length < count) {
      try {
        final data = await _socket!.first.timeout(timeout);
        _buffer.addAll(data);
      } catch (e) {
        return null;
      }
    }

    final result = _buffer.sublist(0, count);
    _buffer.removeRange(0, count);
    return result;
  }

  /// Close connection
  void close() {
    _isConnected = false;
    _socket?.destroy();
    _socket = null;
    _buffer.clear();
  }
}
