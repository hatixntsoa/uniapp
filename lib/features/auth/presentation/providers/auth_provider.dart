import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/models/app_user.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/session_service.dart';

/// Ticket: Gp3-3 / Gp3-4 — auth state notifier + secure session lifecycle
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(const FlutterSecureStorage());
});

final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(const FlutterSecureStorage());
});

class AuthState {
  const AuthState({this.user, this.isLoading = false, this.error});
  final AppUser? user;
  final bool isLoading;
  final String? error;

  AuthState copyWith({AppUser? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService, this._sessionService)
    : super(const AuthState()) {
    _sessionService.onAutoLogout = logout;
  }

  final AuthService _authService;
  final SessionService _sessionService;

  Future<void> login(String identifier, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.login(identifier, password);
      state = AuthState(user: user, isLoading: false);
      _sessionService.startSession();
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _sessionService.stopSession();
    state = const AuthState();
  }

  /// Gp3-4: called on user interaction (taps/scroll) to keep session alive.
  void notifyActivity() => _sessionService.resetIdleTimer();

  void updateProfile(AppUser updated) {
    state = state.copyWith(user: updated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authServiceProvider),
    ref.watch(sessionServiceProvider),
  );
});
