/// Ticket: Gp3-3 — role model used for permission gating
enum UserRole { admin, enseignant, etudiant, technicien }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.admin => 'Administrateur',
    UserRole.enseignant => 'Enseignant',
    UserRole.etudiant => 'Étudiant',
    UserRole.technicien => 'Technicien',
  };
}
