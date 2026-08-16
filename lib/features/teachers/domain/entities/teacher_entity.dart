/// Ticket: Gp4-1 / Gp4-2 — teacher profile + status
enum TeacherStatus { actif, conge, retraite }

extension TeacherStatusX on TeacherStatus {
  String get label => switch (this) {
    TeacherStatus.actif => 'Actif',
    TeacherStatus.conge => 'En congé',
    TeacherStatus.retraite => 'Retraité',
  };
}

class TeacherEntity {
  const TeacherEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.department,
    required this.status,
    required this.subjectIds,
    required this.assignedLevels,
    required this.assignedGroups,
    this.photoUrl,
  });

  final String id;
  final String fullName;
  final String email;
  final String department;
  final TeacherStatus status;
  final List<String> subjectIds;
  final List<String> assignedLevels;
  final List<String> assignedGroups;
  final String? photoUrl;

  TeacherEntity copyWith({
    String? fullName,
    String? department,
    TeacherStatus? status,
    List<String>? subjectIds,
    List<String>? assignedLevels,
    List<String>? assignedGroups,
  }) => TeacherEntity(
    id: id,
    fullName: fullName ?? this.fullName,
    email: email,
    department: department ?? this.department,
    status: status ?? this.status,
    subjectIds: subjectIds ?? this.subjectIds,
    assignedLevels: assignedLevels ?? this.assignedLevels,
    assignedGroups: assignedGroups ?? this.assignedGroups,
    photoUrl: photoUrl,
  );
}
