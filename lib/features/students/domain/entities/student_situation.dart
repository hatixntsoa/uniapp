// Import kept local to avoid a circular file — re-exported below.
import 'student_entity.dart';

/// Ticket: Gp2-3 — global situation view: grades, absences, upcoming exams, notifications
class UpcomingExamSummary {
  const UpcomingExamSummary({
    required this.title,
    required this.date,
    required this.subjectName,
  });
  final String title;
  final DateTime date;
  final String subjectName;
}

class GradeSummary {
  const GradeSummary({
    required this.subjectName,
    required this.grade,
    required this.coefficient,
  });
  final String subjectName;
  final double grade;
  final double coefficient;
}

class StudentSituation {
  const StudentSituation({
    required this.student,
    required this.grades,
    required this.absenceCount,
    required this.justifiedAbsenceCount,
    required this.upcomingExams,
    required this.notificationCount,
  });

  final StudentEntity student;
  final List<GradeSummary> grades;
  final int absenceCount;
  final int justifiedAbsenceCount;
  final List<UpcomingExamSummary> upcomingExams;
  final int notificationCount;
}
