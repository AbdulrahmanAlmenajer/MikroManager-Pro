import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../session/session_controller.dart';

class SessionRefreshNotifier extends ChangeNotifier {
  final Ref _ref;

  SessionRefreshNotifier(this._ref) {
    _ref.listen<SessionState>(
      sessionControllerProvider,
      (prev, next) {
        if (prev?.status != next.status || prev?.session != next.session) {
          notifyListeners();
        }
      },
    );
  }
}

final sessionRefreshNotifierProvider = Provider<SessionRefreshNotifier>((ref) {
  return SessionRefreshNotifier(ref);
});
