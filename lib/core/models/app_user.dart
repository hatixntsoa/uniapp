import 'user_role.dart';

/// Ticket: Gp3-3 / Gp3-4 — shared authenticated user model
class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.matricule,
    this.photoUrl,
  });

  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final String? matricule;
  final String? photoUrl;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    role: UserRole.values.byName(json['role'] as String),
    matricule: json['matricule'] as String?,
    photoUrl: json['photoUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'role': role.name,
    'matricule': matricule,
    'photoUrl': photoUrl,
  };
}
