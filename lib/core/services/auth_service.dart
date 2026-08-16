import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/app_user.dart';
import '../models/user_role.dart';

/// Ticket: Gp3-3 — authentication + session handling.
/// Mocked: validates against an in-memory fixture list instead of the real API.
class AuthService {
  AuthService(this._storage);

  final FlutterSecureStorage _storage;

  static const _mockAccounts = [
    (
      identifier: 'admin@univ.fr',
      password: 'admin123',
      user: AppUser(
        id: 'u-admin-1',
        fullName: 'Nadia Bensalem',
        email: 'admin@univ.fr',
        role: UserRole.admin,
      ),
    ),
    (
      identifier: 'prof@univ.fr',
      password: 'prof123',
      user: AppUser(
        id: 'u-teach-1',
        fullName: 'Karim Haddad',
        email: 'prof@univ.fr',
        role: UserRole.enseignant,
      ),
    ),
    (
      identifier: '20231045',
      password: 'etu123',
      user: AppUser(
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
      user: AppUser(
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
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}
