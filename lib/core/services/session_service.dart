import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Ticket: Gp3-4 — secure session handling (token refresh, auto-logout).
/// Status: mocked refresh (no real backend token yet), but the timer-based
/// auto-logout and refresh scheduling logic is fully functional and can be
/// wired to a real /auth/refresh call by replacing `_mockRefresh`.
class SessionService {
  SessionService(this._storage);

  final FlutterSecureStorage _storage;
  Timer? _refreshTimer;
  Timer? _idleTimer;

  static const _sessionDuration = Duration(minutes: 30);
  static const _refreshBefore = Duration(minutes: 5);
  static const _idleTimeout = Duration(minutes: 15);

  void Function()? onAutoLogout;

  void startSession() {
    _scheduleRefresh();
    resetIdleTimer();
  }

  void _scheduleRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer(_sessionDuration - _refreshBefore, _mockRefresh);
  }

  Future<void> _mockRefresh() async {
    // TODO(Gp3-4): replace with POST /auth/refresh once backend contract
    // is defined. For now, re-issue a mock token to keep the session alive.
    final current = await _storage.read(key: 'auth_token');
    if (current != null) {
      await _storage.write(key: 'auth_token', value: '$current-refreshed');
      _scheduleRefresh();
    }
  }

  void resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(_idleTimeout, () {
      onAutoLogout?.call();
    });
  }

  void stopSession() {
    _refreshTimer?.cancel();
    _idleTimer?.cancel();
  }
}
