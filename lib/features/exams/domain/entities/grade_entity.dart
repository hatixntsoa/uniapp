/// Ticket: Gp1-2 — per-student grade + attendance record for an exam
enum ExamAttendanceStatus { present, absent, late, justified }

extension ExamAttendanceStatusX on ExamAttendanceStatus {
  String get label => switch (this) {
        ExamAttendanceStatus.present => 'Présent',
        ExamAttendanceStatus.absent => 'Absent',
        ExamAttendanceStatus.late => 'Retard',
        ExamAttendanceStatus.justified => 'Justifié',
      };
}

class GradeEntity {
  const GradeEntity({
    required this.studentId,
    required this.studentName,
    required this.attendance,
    this.grade,
    this.plagiarismFlag = false,
  });

  final String studentId;
  final String studentName;
  final ExamAttendanceStatus attendance;
  final double? grade;
  final bool plagiarismFlag;

  GradeEntity copyWith({
    ExamAttendanceStatus? attendance,
    double? grade,
    bool? plagiarismFlag,
  }) =>
      GradeEntity(
        studentId: studentId,
        studentName: studentName,
        attendance: attendance ?? this.attendance,
        grade: grade ?? this.grade,
        plagiarismFlag: plagiarismFlag ?? this.plagiarismFlag,
      );
}