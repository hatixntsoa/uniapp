/// Ticket: Gp1-3 — evaluation types
enum ExamType { continueEval, test, examenFinal, devoir, quiz }

extension ExamTypeX on ExamType {
  String get label => switch (this) {
        ExamType.continueEval => 'Contrôle continu',
        ExamType.test => 'Test',
        ExamType.examenFinal => 'Examen final',
        ExamType.devoir => 'Devoir',
        ExamType.quiz => 'Quiz',
      };
}

/// Ticket: Gp1-1 / Gp1-4 — core exam entity
class ExamEntity {
  const ExamEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.subjectId,
    required this.subjectName,
    required this.teacherId,
    required this.teacherName,
    required this.groupId,
    required this.groupName,
    required this.date,
    required this.durationMinutes,
    required this.bareme,
    required this.coefficient,
    this.isPublished = false,
  });

  final String id;
  final String title;
  final ExamType type;
  final String subjectId;
  final String subjectName;
  final String teacherId;
  final String teacherName;
  final String groupId;
  final String groupName;
  final DateTime date;
  final int durationMinutes;
  final double bareme;
  final double coefficient;
  final bool isPublished;

  ExamEntity copyWith({bool? isPublished}) => ExamEntity(
        id: id,
        title: title,
        type: type,
        subjectId: subjectId,
        subjectName: subjectName,
        teacherId: teacherId,
        teacherName: teacherName,
        groupId: groupId,
        groupName: groupName,
        date: date,
        durationMinutes: durationMinutes,
        bareme: bareme,
        coefficient: coefficient,
        isPublished: isPublished ?? this.isPublished,
      );
}