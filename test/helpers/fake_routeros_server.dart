import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A lightweight, in-memory MikroTik RouterOS Binary API TCP Simulator.
///
/// Implements MikroTik 1-to-5-byte length-word binary protocol.
/// Emulates both RouterOS v6.49 and RouterOS v7.18+ with full fault injection.
class FakeRouterOsServer {
  ServerSocket? _server;
  final List<Socket> _activeSockets = [];

  bool isV7 = false;
  String v6Customer = 'admin@2021';
  bool triggerTimeout = false;
  String? triggerTrapMessage;
  bool triggerDisconnect = false;
  bool sendEmptyOnEmptyTables = false;

  final List<Map<String, String>> v6Users = [];
  final List<Map<String, String>> v7Users = [];
  final List<String> receivedCommands = [];

  int get port => _server?.port ?? 0;

  Future<int> start({int port = 0}) async {
    _server = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
    _server!.listen(_handleClient);
    return _server!.port;
  }

  Future<void> stop() async {
    final socketsCopy = List<Socket>.from(_activeSockets);
    for (final s in socketsCopy) {
      try {
        s.destroy();
      } on Object catch (_) {}
    }
    _activeSockets.clear();
    await _server?.close();
    _server = null;
  }

  void _handleClient(Socket socket) {
    _activeSockets.add(socket);
    final List<int> buffer = [];

    socket.listen(
      (data) {
        buffer.addAll(data);
        _processBuffer(socket, buffer);
      },
      onDone: () => _activeSockets.remove(socket),
      onError: (_) => _activeSockets.remove(socket),
    );
  }

  void _processBuffer(Socket socket, List<int> buffer) {
    while (true) {
      final sentence = _tryParseSentence(buffer);
      if (sentence == null) break;

      if (triggerDisconnect) {
        socket.destroy();
        _activeSockets.remove(socket);
        return;
      }

      if (triggerTimeout) {
        // Drop the command and do not reply (simulate network timeout)
        continue;
      }

      _dispatchCommand(socket, sentence);
    }
  }

  List<String>? _tryParseSentence(List<int> buffer) {
    final List<String> words = [];
    int offset = 0;

    while (true) {
      if (offset >= buffer.length) return null;
      final lenResult = _decodeLength(buffer, offset);
      if (lenResult == null) return null;

      final len = lenResult.length;
      final headerSize = lenResult.headerSize;
      final dataStart = offset + headerSize;

      if (buffer.length < dataStart + len) return null;

      offset = dataStart + len;
      if (len == 0) {
        // Sentence boundary reached!
        buffer.removeRange(0, offset);
        return words;
      } else {
        final wordBytes = buffer.sublist(dataStart, offset);
        final word = utf8.decode(wordBytes, allowMalformed: true);
        words.add(word);
      }
    }
  }

  void _dispatchCommand(Socket socket, List<String> words) {
    if (words.isEmpty) return;

    final cmd = words.first;
    receivedCommands.add(cmd);

    String? tag;
    final Map<String, String> attrs = {};
    for (int i = 1; i < words.length; i++) {
      final w = words[i];
      if (w.startsWith('.tag=')) {
        tag = w.substring(5);
      } else if (w.startsWith('=')) {
        final eq = w.indexOf('=', 1);
        if (eq != -1) {
          attrs[w.substring(1, eq)] = w.substring(eq + 1);
        } else {
          attrs[w.substring(1)] = '';
        }
      }
    }

    if (triggerTrapMessage != null) {
      _sendSentence(socket, '!trap', {'message': triggerTrapMessage!}, tag);
      _sendSentence(socket, '!done', {}, tag);
      return;
    }

    switch (cmd) {
      case '/login':
        _handleLogin(socket, attrs, tag);
        break;
      case '/system/resource/print':
        _handleSystemResource(socket, tag);
        break;
      case '/user/print':
        _sendSentence(socket, '!re',
            {'group': 'full', 'name': attrs['name'] ?? 'admin'}, tag);
        _sendSentence(socket, '!done', {}, tag);
        break;
      case '/user/group/print':
        _sendSentence(socket, '!re',
            {'name': 'full', 'policy': 'api,read,write,policy'}, tag);
        _sendSentence(socket, '!done', {}, tag);
        break;
      case '/tool/user-manager/customer/print':
        _sendSentence(socket, '!re', {'login': v6Customer}, tag);
        _sendSentence(socket, '!done', {}, tag);
        break;
      case '/tool/user-manager/profile/print':
        _sendSentence(
            socket,
            '!re',
            {
              '.id': '*1',
              'name': '1Hour',
              'owner': v6Customer,
              'validity': '1h',
              'price': '100',
              'shared-users': '1',
            },
            tag);
        _sendSentence(socket, '!done', {}, tag);
        break;
      case '/tool/user-manager/user/print':
        if (v6Users.isEmpty && sendEmptyOnEmptyTables) {
          _sendSentence(socket, '!empty', {}, null);
        } else {
          for (final u in v6Users) {
            _sendSentence(socket, '!re', u, tag);
          }
          _sendSentence(socket, '!done', {}, tag);
        }
        break;
      case '/tool/user-manager/user/add':
        final username = attrs['username'] ?? attrs['name'] ?? '';
        final cust = attrs['customer'] ?? v6Customer;
        v6Users.add({
          '.id': '*${v6Users.length + 1}',
          'username': username,
          'customer': cust,
          'actual-profile': '',
          'uptime-used': '0',
          'download-used': '0',
          'upload-used': '0',
        });
        _sendSentence(socket, '!done', {'ret': '*${v6Users.length}'}, tag);
        break;
      case '/tool/user-manager/user/create-and-activate-profile':
        final user = attrs['user'] ?? '';
        final prof = attrs['profile'] ?? '';
        for (final u in v6Users) {
          if (u['username'] == user) {
            u['actual-profile'] = prof;
          }
        }
        _sendSentence(socket, '!done', {}, tag);
        break;
      case '/user-manager/user/print':
        if (v7Users.isEmpty && sendEmptyOnEmptyTables) {
          _sendSentence(socket, '!empty', {}, null);
        } else {
          for (final u in v7Users) {
            _sendSentence(socket, '!re', u, tag);
          }
          _sendSentence(socket, '!done', {}, tag);
        }
        break;
      case '/user-manager/profile/print':
        _sendSentence(
            socket,
            '!re',
            {
              '.id': '*P1',
              'name': '24Hours',
              'name-for-users': 'يوم كامل',
              'price': '500',
              'validity': '1d',
            },
            tag);
        _sendSentence(socket, '!done', {}, tag);
        break;
      case '/user-manager/user/add':
        final name = attrs['name'] ?? '';
        v7Users.add({
          '.id': '*U${v7Users.length + 1}',
          'name': name,
          'group': 'default',
        });
        _sendSentence(socket, '!done', {'ret': '*U${v7Users.length}'}, tag);
        break;
      case '/user-manager/user-profile/add':
        _sendSentence(socket, '!done', {}, tag);
        break;
      default:
        _sendSentence(socket, '!done', {}, tag);
    }
  }

  void _handleLogin(Socket socket, Map<String, String> attrs, String? tag) {
    if (attrs.containsKey('name')) {
      _sendSentence(socket, '!done', {}, tag);
    } else {
      // Legacy challenge response
      _sendSentence(socket, '!done', {'ret': 'abcdef1234567890'}, tag);
    }
  }

  void _handleSystemResource(Socket socket, String? tag) {
    final ver = isV7 ? '7.18.1 (stable)' : '6.49.10 (long-term)';
    _sendSentence(
        socket,
        '!re',
        {
          'version': ver,
          'uptime': '10d2h',
          'cpu-load': '12',
          'free-memory': '268435456',
          'total-memory': '536870912',
          'free-hdd-space': '67108864',
          'total-hdd-space': '134217728',
          'board-name': isV7 ? 'CCR2004-1G-12S+2XS' : 'RB1100AHx4',
        },
        tag);
    _sendSentence(socket, '!done', {}, tag);
  }

  void _sendSentence(
      Socket socket, String command, Map<String, String> attrs, String? tag) {
    final List<String> words = [command];
    attrs.forEach((k, v) => words.add('=$k=$v'));
    if (tag != null) words.add('.tag=$tag');

    for (final w in words) {
      _writeWord(socket, w);
    }
    _writeWord(socket, ''); // Empty word terminates sentence
  }

  void _writeWord(Socket socket, String word) {
    final bytes = utf8.encode(word);
    final lenBytes = _encodeLength(bytes.length);
    socket.add(lenBytes);
    socket.add(bytes);
  }

  static List<int> _encodeLength(int len) {
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

  static _LenDecode? _decodeLength(List<int> bytes, int offset) {
    if (bytes.length <= offset) return null;
    final b1 = bytes[offset];
    if ((b1 & 0x80) == 0x00) {
      return _LenDecode(b1, 1);
    } else if ((b1 & 0xC0) == 0x80) {
      if (bytes.length < offset + 2) return null;
      return _LenDecode(((b1 & 0x3F) << 8) | bytes[offset + 1], 2);
    } else if ((b1 & 0xE0) == 0xC0) {
      if (bytes.length < offset + 3) return null;
      return _LenDecode(
          ((b1 & 0x1F) << 16) | (bytes[offset + 1] << 8) | bytes[offset + 2],
          3);
    } else if ((b1 & 0xF0) == 0xE0) {
      if (bytes.length < offset + 4) return null;
      return _LenDecode(
          ((b1 & 0x0F) << 24) |
              (bytes[offset + 1] << 16) |
              (bytes[offset + 2] << 8) |
              bytes[offset + 3],
          4);
    } else if (b1 == 0xF0) {
      if (bytes.length < offset + 5) return null;
      return _LenDecode(
          (bytes[offset + 1] << 24) |
              (bytes[offset + 2] << 16) |
              (bytes[offset + 3] << 8) |
              bytes[offset + 4],
          5);
    }
    return null;
  }
}

class _LenDecode {
  final int length;
  final int headerSize;
  _LenDecode(this.length, this.headerSize);
}
