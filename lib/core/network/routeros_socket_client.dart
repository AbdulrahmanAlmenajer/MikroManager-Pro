import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import '../utils/cancellation_token.dart';
import 'routeros_exceptions.dart';

class RouterOsSentence {
  final String command; // !re, !done, !trap, !fatal
  final Map<String, String> attributes;
  final String? tag;

  RouterOsSentence({
    required this.command,
    required this.attributes,
    this.tag,
  });

  @override
  String toString() => '$command [tag: $tag]: $attributes';
}

class RouterOsResponse {
  final bool isSuccess;
  final List<Map<String, String>> data;
  final String? errorMessage;
  final String? tag;

  RouterOsResponse({
    required this.isSuccess,
    this.data = const [],
    this.errorMessage,
    this.tag,
  });
}

class RouterOsSocketClient {
  final String host;
  final int port;
  final String username;
  final String password;
  final bool useSsl;
  final bool acceptSelfSigned;
  final Duration timeout;

  Socket? _socket;
  StreamSubscription<List<int>>? _socketSub;
  bool _isConnected = false;
  int _tagCounter = 0;

  final List<int> _readBuffer = [];

  // Stream controllers for active queries
  final Map<String, Completer<RouterOsResponse>> _pendingRequests = {};
  final Map<String, StreamController<Map<String, String>>> _activeStreams = {};

  RouterOsSocketClient({
    required this.host,
    this.port = 8728,
    required this.username,
    required this.password,
    this.useSsl = false,
    this.acceptSelfSigned = true,
    this.timeout = const Duration(seconds: 8),
  });

  bool get isConnected => _isConnected && _socket != null;

  /// Connect to RouterOS with automatic retry (up to 3 times)
  Future<bool> connectWithRetry({int maxRetries = 3}) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      attempts++;
      try {
        final success = await connect();
        if (success) return true;
      } catch (e) {
        if (attempts >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 300 * attempts));
      }
    }
    return false;
  }

  /// Connect and authenticate with RouterOS
  Future<bool> connect() async {
    close();

    try {
      if (useSsl) {
        _socket = await SecureSocket.connect(
          host,
          port,
          timeout: timeout,
          onBadCertificate: (cert) => acceptSelfSigned,
        );
      } else {
        _socket = await Socket.connect(host, port, timeout: timeout);
      }

      _isConnected = true;
      _startSocketListener();

      return await _login();
    } on SocketException catch (e) {
      close();
      final err = e.osError?.errorCode ?? 0;
      final msg = e.message.toLowerCase();
      if (err == 111 ||
          err == 10061 ||
          msg.contains('refused') ||
          msg.contains('closed')) {
        throw RouterOsPortClosedException(e.toString());
      } else if (err == 113 ||
          err == 10065 ||
          msg.contains('no route') ||
          msg.contains('unreachable')) {
        throw RouterOsUnreachableException(e.toString());
      }
      throw RouterOsPortClosedException(e.toString());
    } on TimeoutException catch (e) {
      close();
      throw RouterOsTimeoutException(e.toString());
    } on HandshakeException catch (e) {
      close();
      throw RouterOsTlsException(e.toString());
    } on TlsException catch (e) {
      close();
      throw RouterOsTlsException(e.toString());
    } catch (e) {
      close();
      if (e is RouterOsException) rethrow;
      throw RouterOsProtocolException('فشل الاتصال: ${e.toString()}');
    }
  }

  void _startSocketListener() {
    _socketSub = _socket?.listen(
      (data) {
        _readBuffer.addAll(data);
        _processBuffer();
      },
      onError: (err) {
        close();
      },
      onDone: () {
        close();
      },
      cancelOnError: true,
    );
  }

  /// Login protocol: supports both Post-6.43 and Legacy MD5
  Future<bool> _login() async {
    // 1. Post-6.43 direct login: /login =name= =password=
    final firstAttempt = await executeSentence([
      '/login',
      '=name=$username',
      '=password=$password',
    ]);

    if (firstAttempt.isSuccess) {
      return true;
    }

    // 2. Legacy MD5 challenge flow (RouterOS < 6.43)
    final challengeAttempt = await executeSentence(['/login']);
    String? challenge;
    for (final item in challengeAttempt.data) {
      if (item.containsKey('ret')) {
        challenge = item['ret'];
        break;
      }
    }

    if (challenge != null && challenge.isNotEmpty) {
      final md5Response = computeLegacyMd5(password, challenge);
      final legacyLogin = await executeSentence([
        '/login',
        '=name=$username',
        '=response=$md5Response',
      ]);
      if (legacyLogin.isSuccess) return true;
    }

    throw const RouterOsAuthException(
        'فشل التحقق من اسم المستخدم أو كلمة المرور');
  }

  /// Legacy MD5 login challenge hash
  static String computeLegacyMd5(String password, String challengeHex) {
    final List<int> challengeBytes = [];
    for (int i = 0; i < challengeHex.length; i += 2) {
      challengeBytes
          .add(int.parse(challengeHex.substring(i, i + 2), radix: 16));
    }

    final List<int> toHash = [0];
    toHash.addAll(utf8.encode(password));
    toHash.addAll(challengeBytes);

    final digest = md5.convert(toHash);
    return '00${digest.toString()}';
  }

  /// Cancel an active sentence query by its tag
  Future<void> cancelTag(String tag) async {
    if (isConnected) {
      try {
        _writeWord('/cancel');
        _writeWord('=tag=$tag');
        _writeWord('');
        await _socket?.flush();
      } catch (_) {}
    }
    _pendingRequests.remove(tag);
    _tempReplies.remove(tag);
    _activeStreams[tag]?.close();
    _activeStreams.remove(tag);
  }

  /// Execute command and wait for response.
  /// [commandTimeout] overrides the default [timeout] for this call only.
  /// Use [Duration(seconds: 60)] for large User Manager table fetches.
  Future<RouterOsResponse> executeSentence(
    List<String> words, {
    Duration? commandTimeout,
    CancellationToken? cancelToken,
  }) async {
    if (!isConnected) {
      throw const RouterOsUnreachableException('الاتصال بميكروتك غير متاح');
    }

    cancelToken?.throwIfCancelled();

    final effectiveTimeout = commandTimeout ?? timeout;
    final tag = 'tag_${++_tagCounter}';
    final completer = Completer<RouterOsResponse>();
    _pendingRequests[tag] = completer;

    void onCancel() {
      cancelTag(tag);
      if (!completer.isCompleted) {
        completer.completeError(
          const OperationCancelledException('تم إلغاء الأمر من قبل المستخدم'),
        );
      }
    }

    cancelToken?.addListener(onCancel);

    // Send command with tag
    final List<String> taggedWords = List.from(words)..add('.tag=$tag');
    for (final word in taggedWords) {
      _writeWord(word);
    }
    _writeWord(''); // Empty word terminates sentence
    await _socket!.flush();

    try {
      return await completer.future.timeout(effectiveTimeout);
    } on TimeoutException {
      _pendingRequests.remove(tag);
      _tempReplies.remove(tag);
      throw RouterOsTimeoutException(
          'انتهت مهلة انتظار رد الراوتر للأمر: ${words.first}');
    } finally {
      cancelToken?.removeListener(onCancel);
    }
  }

  /// Stream continuous commands (e.g., /interface/monitor-traffic or /listen)
  Stream<Map<String, String>> streamSentence(List<String> words) {
    if (!isConnected) {
      throw const RouterOsUnreachableException('الاتصال بميكروتك غير متاح');
    }

    final tag = 'stream_${++_tagCounter}';
    final controller = StreamController<Map<String, String>>(
      onCancel: () async {
        if (isConnected) {
          // Send cancel command with tag – ignore write errors (socket may have closed)
          try {
            _writeWord('/cancel');
            _writeWord('=tag=$tag');
            _writeWord('');
            await _socket?.flush();
          } on Object catch (e) {
            // Stream cancel write failure is non-fatal; just log to assert in debug
            assert(false, 'Stream cancel write failed: $e');
          }
        }
        _activeStreams.remove(tag);
      },
    );

    _activeStreams[tag] = controller;

    final List<String> taggedWords = List.from(words)..add('.tag=$tag');
    for (final word in taggedWords) {
      _writeWord(word);
    }
    _writeWord('');
    _socket?.flush();

    return controller.stream;
  }

  void _processBuffer() {
    while (true) {
      final sentence = _tryParseSentence();
      if (sentence == null) break;

      final tag = sentence.tag;

      // --- RouterOS 7.18+: untagged `!empty` sentence ---
      // Sent as an end-of-results marker for empty tables (no .tag).
      // Resolve the single oldest pending request with an empty success.
      if (tag == null && sentence.command == '!empty') {
        if (_pendingRequests.isNotEmpty) {
          final firstTag = _pendingRequests.keys.first;
          final completer = _pendingRequests.remove(firstTag)!;
          _tempReplies.remove(firstTag);
          completer.complete(
              RouterOsResponse(isSuccess: true, data: const [], tag: firstTag));
        }
        continue;
      }

      if (tag != null) {
        if (_activeStreams.containsKey(tag)) {
          final stream = _activeStreams[tag]!;
          if (sentence.command == '!re') {
            stream.add(sentence.attributes);
          } else if (sentence.command == '!done' ||
              sentence.command == '!empty') {
            stream.close();
            _activeStreams.remove(tag);
          } else if (sentence.command == '!trap') {
            stream.addError(RouterOsProtocolException(
                sentence.attributes['message'] ?? 'Trap error'));
            stream.close();
            _activeStreams.remove(tag);
          }
          continue;
        }

        if (_pendingRequests.containsKey(tag)) {
          final completer = _pendingRequests[tag]!;
          if (sentence.command == '!re') {
            _tempReplies.putIfAbsent(tag, () => []).add(sentence.attributes);
          } else if (sentence.command == '!done' ||
              sentence.command == '!empty') {
            // `!empty` with a tag = valid empty-result for that tag
            final data = _tempReplies.remove(tag) ?? [];
            if (sentence.attributes.isNotEmpty) {
              data.add(sentence.attributes);
            }
            _pendingRequests.remove(tag);
            completer.complete(
                RouterOsResponse(isSuccess: true, data: data, tag: tag));
          } else if (sentence.command == '!trap') {
            _tempReplies.remove(tag);
            _pendingRequests.remove(tag);
            completer.complete(RouterOsResponse(
              isSuccess: false,
              errorMessage: sentence.attributes['message'] ?? 'Trap error',
              tag: tag,
            ));
          } else if (sentence.command == '!fatal') {
            _tempReplies.remove(tag);
            _pendingRequests.remove(tag);
            close();
            completer.complete(RouterOsResponse(
              isSuccess: false,
              errorMessage: 'Fatal connection error',
              tag: tag,
            ));
          }
        }
      }
    }
  }

  final Map<String, List<Map<String, String>>> _tempReplies = {};

  RouterOsSentence? _tryParseSentence() {
    final List<String> words = [];
    int offset = 0;

    while (true) {
      final wordResult = _tryReadWord(offset);
      if (wordResult == null) return null; // Incomplete data in buffer

      offset = wordResult.newOffset;
      if (wordResult.word.isEmpty) {
        // Sentence boundary reached!
        _readBuffer.removeRange(0, offset);
        if (words.isEmpty) return null;

        final command = words.first;
        final Map<String, String> attributes = {};
        String? tag;

        for (int i = 1; i < words.length; i++) {
          final w = words[i];
          if (w.startsWith('.tag=')) {
            tag = w.substring(5);
          } else if (w.startsWith('=')) {
            final eq = w.indexOf('=', 1);
            if (eq != -1) {
              attributes[w.substring(1, eq)] = w.substring(eq + 1);
            } else {
              attributes[w.substring(1)] = '';
            }
          }
        }

        return RouterOsSentence(
            command: command, attributes: attributes, tag: tag);
      } else {
        words.add(wordResult.word);
      }
    }
  }

  _WordReadResult? _tryReadWord(int offset) {
    final lenResult = decodeLength(_readBuffer, offset);
    if (lenResult == null) return null;

    final length = lenResult.length;
    final headerSize = lenResult.headerSize;
    final dataStart = offset + headerSize;

    if (_readBuffer.length < dataStart + length) return null;

    final wordBytes = _readBuffer.sublist(dataStart, dataStart + length);
    final word = utf8.decode(wordBytes, allowMalformed: true);
    return _WordReadResult(word: word, newOffset: dataStart + length);
  }

  /// Write length-encoded word according to MikroTik specification
  void _writeWord(String word) {
    final bytes = utf8.encode(word);
    final lenBytes = encodeLength(bytes.length);
    _socket?.add(lenBytes);
    _socket?.add(bytes);
  }

  /// Encode word length according to MikroTik 1 to 5 byte specification
  static List<int> encodeLength(int len) {
    if (len < 0x80) {
      return [len];
    } else if (len < 0x4000) {
      final val = len | 0x8000;
      return [(val >> 8) & 0xFF, val & 0xFF];
    } else if (len < 0x200000) {
      final val = len | 0xC00000;
      return [(val >> 16) & 0xFF, (val >> 8) & 0xFF, val & 0xFF];
    } else if (len < 0x10000000) {
      final val = len | 0xE0000000;
      return [
        (val >> 24) & 0xFF,
        (val >> 16) & 0xFF,
        (val >> 8) & 0xFF,
        val & 0xFF
      ];
    } else {
      return [
        0xF0,
        (len >> 24) & 0xFF,
        (len >> 16) & 0xFF,
        (len >> 8) & 0xFF,
        len & 0xFF,
      ];
    }
  }

  /// Decode length header bytes (1 to 5 bytes)
  static LengthDecodeResult? decodeLength(List<int> bytes, [int offset = 0]) {
    if (bytes.length <= offset) return null;
    final b1 = bytes[offset];

    if ((b1 & 0x80) == 0x00) {
      return LengthDecodeResult(length: b1, headerSize: 1);
    } else if ((b1 & 0xC0) == 0x80) {
      if (bytes.length < offset + 2) return null;
      final b2 = bytes[offset + 1];
      return LengthDecodeResult(length: ((b1 & 0x3F) << 8) | b2, headerSize: 2);
    } else if ((b1 & 0xE0) == 0xC0) {
      if (bytes.length < offset + 3) return null;
      final b2 = bytes[offset + 1];
      final b3 = bytes[offset + 2];
      return LengthDecodeResult(
          length: ((b1 & 0x1F) << 16) | (b2 << 8) | b3, headerSize: 3);
    } else if ((b1 & 0xF0) == 0xE0) {
      if (bytes.length < offset + 4) return null;
      final b2 = bytes[offset + 1];
      final b3 = bytes[offset + 2];
      final b4 = bytes[offset + 3];
      return LengthDecodeResult(
          length: ((b1 & 0x0F) << 24) | (b2 << 16) | (b3 << 8) | b4,
          headerSize: 4);
    } else if (b1 == 0xF0) {
      if (bytes.length < offset + 5) return null;
      final b2 = bytes[offset + 1];
      final b3 = bytes[offset + 2];
      final b4 = bytes[offset + 3];
      final b5 = bytes[offset + 4];
      return LengthDecodeResult(
          length: (b2 << 24) | (b3 << 16) | (b4 << 8) | b5, headerSize: 5);
    }
    return null;
  }

  void close() {
    _isConnected = false;
    _socketSub?.cancel();
    _socketSub = null;
    _socket?.destroy();
    _socket = null;
    _readBuffer.clear();
    // Complete all pending requests with a connection-closed error
    for (final entry in _pendingRequests.entries) {
      entry.value.complete(RouterOsResponse(
        isSuccess: false,
        errorMessage: 'الاتصال انقطع قبل اكتمال العملية',
        tag: entry.key,
      ));
    }
    _pendingRequests.clear();
    _tempReplies.clear();
    for (final s in _activeStreams.values) {
      s.addError(const RouterOsProtocolException('الاتصال انقطع'));
      s.close();
    }
    _activeStreams.clear();
  }
}

class LengthDecodeResult {
  final int length;
  final int headerSize;
  const LengthDecodeResult({required this.length, required this.headerSize});
}

class _WordReadResult {
  final String word;
  final int newOffset;
  const _WordReadResult({required this.word, required this.newOffset});
}
