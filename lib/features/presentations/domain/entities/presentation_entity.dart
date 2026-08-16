/// Ticket: Gp10-1 — presentation (individual/group, members, order, grading criteria)
enum PresentationMode { individuelle, groupe }

extension PresentationModeX on PresentationMode {
  String get label => switch (this) {
    PresentationMode.individuelle => 'Individuelle',
    PresentationMode.groupe => 'En groupe',
  };
}

class GradingCriterion {
  const GradingCriterion({
    required this.id,
    required this.label,
    required this.maxPoints,
  });
  final String id;
  final String label;
  final double maxPoints;
}

class PresentationMember {
  const PresentationMember({
    required this.studentId,
    required this.studentName,
    required this.order,
  });
  final String studentId;
  final String studentName;
  final int order;
}

class PresentationEntity {
  const PresentationEntity({
    required this.id,
    required this.title,
    required this.mode,
    required this.subjectName,
    required this.date,
    required this.members,
    required this.criteria,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final PresentationMode mode;
  final String subjectName;
  final DateTime date;
  final List<PresentationMember> members;
  final List<GradingCriterion> criteria;
  final bool isCompleted;

  PresentationEntity copyWith({bool? isCompleted}) => PresentationEntity(
    id: id,
    title: title,
    mode: mode,
    subjectName: subjectName,
    date: date,
    members: members,
    criteria: criteria,
    isCompleted: isCompleted ?? this.isCompleted,
  );
}
