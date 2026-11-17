import 'dart:async';
import 'package:flutter/foundation.dart';
import 'routeros_adapter.dart';
import 'routeros_socket_client.dart';

/// Central command scheduler for RouterOS.
///
/// Features:
/// 1. Request de-duplication: concurrent identical in-flight queries share one response.
/// 2. Shared polling streams: multiple UI components subscribe to one shared polling stream.
/// 3. Exponential backoff on errors to avoid overwhelming a struggling router.
/// 4. Safe cancellation on dispose or logout.
class RouterOsCommandScheduler {
  final RouterOsAdapter adapter;
  final int connectionId;

  // In-flight query de-duplication
  final Map<String, Future<RouterOsResponse>> _inFlightQueries = {};

  // Active polling streams by key
  final Map<String, _PollingStreamController<dynamic>> _pollingStreams = {};

  RouterOsCommandScheduler({
    required this.adapter,
    required this.connectionId,
  });

  /// Executes a command sentence with optional query de-duplication
  Future<RouterOsResponse> execute(
    List<String> words, {
    bool deduplicate = true,
  }) async {
    final queryKey = words.join('|');

    if (deduplicate && _inFlightQueries.containsKey(queryKey)) {
      debugPrint('[Scheduler] De-duplicating in-flight query: $queryKey');
      return _inFlightQueries[queryKey]!;
    }

    final future = adapter.executeSentence(words);
    if (deduplicate) {
      _inFlightQueries[queryKey] = future;
      future.whenComplete(() {
        _inFlightQueries.remove(queryKey);
      });
    }

    return future;
  }

  /// Registers or retrieves a shared polling stream.
  /// When listeners are active, ticks periodically at [interval].
  /// On error, applies exponential backoff up to [maxBackoff].
  /// When all listeners detach, polling pauses automatically.
  Stream<T> registerPollingStream<T>({
    required String key,
    required Duration interval,
    required Future<T> Function() fetcher,
    Duration maxBackoff = const Duration(seconds: 30),
  }) {
    if (_pollingStreams.containsKey(key)) {
      return (_pollingStreams[key] as _PollingStreamController<T>).stream;
    }

    final controller = _PollingStreamController<T>(
      key: key,
      baseInterval: interval,
      maxBackoff: maxBackoff,
      fetcher: fetcher,
      onEmpty: () {
        _pollingStreams.remove(key);
      },
    );

    _pollingStreams[key] = controller;
    return controller.stream;
  }

  /// Cancels all polling timers and clears in-flight state
  void dispose() {
    for (final controller in _pollingStreams.values) {
      controller.dispose();
    }
    _pollingStreams.clear();
    _inFlightQueries.clear();
  }
}

class _PollingStreamController<T> {
  final String key;
  final Duration baseInterval;
  final Duration maxBackoff;
  final Future<T> Function() fetcher;
  final VoidCallback onEmpty;

  late final StreamController<T> _controller;
  Timer? _timer;
  int _consecutiveErrors = 0;
  bool _isFetching = false;
  bool _isDisposed = false;

  _PollingStreamController({
    required this.key,
    required this.baseInterval,
    required this.maxBackoff,
    required this.fetcher,
    required this.onEmpty,
  }) {
    _controller = StreamController<T>.broadcast(
      onListen: _onListen,
      onCancel: _onCancel,
    );
  }

  Stream<T> get stream => _controller.stream;

  void _onListen() {
    if (_isDisposed) return;
    _scheduleNext(Duration.zero);
  }

  void _onCancel() {
    if (!_controller.hasListener) {
      _timer?.cancel();
      _timer = null;
      onEmpty();
    }
  }

  void _scheduleNext(Duration delay) {
    if (_isDisposed || !_controller.hasListener) return;
    _timer?.cancel();
    _timer = Timer(delay, _poll);
  }

  Future<void> _poll() async {
    if (_isDisposed || !_controller.hasListener || _isFetching) return;
    _isFetching = true;

    try {
      final result = await fetcher();
      if (!_controller.isClosed) {
        _controller.add(result);
      }
      _consecutiveErrors = 0;
      _scheduleNext(baseInterval);
    } catch (e) {
      _consecutiveErrors++;
      // Exponential backoff
      final multiplier = 1 << (_consecutiveErrors > 5 ? 5 : _consecutiveErrors);
      var nextDelay = Duration(milliseconds: baseInterval.inMilliseconds * multiplier);
      if (nextDelay > maxBackoff) nextDelay = maxBackoff;

      debugPrint('[Scheduler] Error on $key, backing off for ${nextDelay.inSeconds}s: $e');
      _scheduleNext(nextDelay);
    } finally {
      _isFetching = false;
    }
  }

  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    _controller.close();
  }
}
