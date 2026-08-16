/// Ticket: Gp5-1 — subject entity (code, coefficient, volume horaire, semestre, niveau, enseignant)
class SubjectEntity {
  const SubjectEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.coefficient,
    required this.volumeHoraire,
    required this.semestre,
    required this.niveau,
    required this.filiere,
    required this.teacherId,
    required this.teacherName,
  });

  final String id;
  final String code;
  final String name;
  final double coefficient;
  final int volumeHoraire; // hours
  final String semestre;
  final String niveau;
  final String filiere;
  final String teacherId;
  final String teacherName;

  SubjectEntity copyWith({
    String? name,
    double? coefficient,
    int? volumeHoraire,
    String? teacherId,
    String? teacherName,
  }) => SubjectEntity(
    id: id,
    code: code,
    name: name ?? this.name,
    coefficient: coefficient ?? this.coefficient,
    volumeHoraire: volumeHoraire ?? this.volumeHoraire,
    semestre: semestre,
    niveau: niveau,
    filiere: filiere,
    teacherId: teacherId ?? this.teacherId,
    teacherName: teacherName ?? this.teacherName,
  );
}
