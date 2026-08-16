import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/app_user.dart';
import '../models/user_role.dart';

/// Ticket: Gp3-3 / Gp3-4 — authentication + session handling.
/// Mocked: validates against an in-memory fixture list instead of the real API.
class AuthService {
  AuthService(this._storage);

  final FlutterSecureStorage _storage;

  static final _mockAccounts = [
    (
      identifier: 'admin@univ.fr',
      password: 'admin123',
      user: const AppUser(
        id: 'u-admin-1',
        fullName: 'Nadia Bensalem',
        email: 'admin@univ.fr',
        role: UserRole.admin,
      ),
    ),
    (
      identifier: 'prof@univ.fr',
      password: 'prof123',
      user: const AppUser(
        id: 'u-teach-1',
        fullName: 'Karim Haddad',
        email: 'prof@univ.fr',
        role: UserRole.enseignant,
      ),
    ),
    (
      identifier: '20231045',
      password: 'etu123',
      user: const AppUser(
        id: 'u-stud-1',
        fullName: 'Lina Meziane',
        email: 'lina.meziane@etu.univ.fr',
        role: UserRole.etudiant,
        matricule: '20231045',
      ),
    ),
    (
      identifier: 'tech@univ.fr',
      password: 'tech123',
      user: const AppUser(
        id: 'u-tech-1',
        fullName: 'Yacine Ouali',
        email: 'tech@univ.fr',
        role: UserRole.technicien,
      ),
    ),
  ];

  Future<AppUser> login(String identifier, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final match = _mockAccounts.where(
      (a) => a.identifier == identifier && a.password == password,
    );
    if (match.isEmpty) {
      throw AuthException('Identifiants incorrects');
    }
    final user = match.first.user;
    await _storage.write(key: 'auth_token', value: 'mock-token-${user.id}');
    await _storage.write(key: 'auth_role', value: user.role.name);
    return user;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'auth_role');
  }

  Future<bool> hasSession() async {
    return (await _storage.read(key: 'auth_token')) != null;
  }

  /// Gp3-3: password reset request.
  /// Status: mocked — simulates sending a reset email; no real email is sent.
  Future<void> requestPasswordReset(String identifier) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final exists = _mockAccounts.any((a) => a.identifier == identifier);
    if (!exists) {
      throw AuthException('Aucun compte associé à cet identifiant');
    }
    // Backend placeholder: replace with POST /auth/password-reset once the backend exists.
  }

  /// Gp3-4: change password for the currently authenticated user.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO(Gp3-4): call real PUT /auth/password once backend exists.
    // Mocked: always succeeds if currentPassword is non-empty.
    if (currentPassword.isEmpty) {
      throw AuthException('Mot de passe actuel incorrect');
    }
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}
