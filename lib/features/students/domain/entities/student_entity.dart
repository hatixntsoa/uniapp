/// Ticket: Gp2-1 — student entity with level/filière/group/year
class StudentEntity {
  const StudentEntity({
    required this.id,
    required this.fullName,
    required this.matricule,
    required this.email,
    required this.filiere,
    required this.niveau,
    required this.groupName,
    required this.anneeUniversitaire,
    this.photoUrl,
    this.isArchived = false,
  });

  final String id;
  final String fullName;
  final String matricule;
  final String email;
  final String filiere;
  final String niveau;
  final String groupName;
  final String anneeUniversitaire;
  final String? photoUrl;
  final bool isArchived;

  StudentEntity copyWith({
    String? fullName,
    String? filiere,
    String? niveau,
    String? groupName,
    bool? isArchived,
  }) => StudentEntity(
    id: id,
    fullName: fullName ?? this.fullName,
    matricule: matricule,
    email: email,
    filiere: filiere ?? this.filiere,
    niveau: niveau ?? this.niveau,
    groupName: groupName ?? this.groupName,
    anneeUniversitaire: anneeUniversitaire,
    photoUrl: photoUrl,
    isArchived: isArchived ?? this.isArchived,
  );
}
