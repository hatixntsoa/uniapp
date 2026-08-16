/// Ticket: Gp2-5 — reports: by student, by course, rate by group, alerts
class GroupAttendanceRate {
  const GroupAttendanceRate({
    required this.groupName,
    required this.presentCount,
    required this.totalCount,
  });
  final String groupName;
  final int presentCount;
  final int totalCount;

  double get rate => totalCount == 0 ? 0 : presentCount / totalCount;
}

class AbsenceAlert {
  const AbsenceAlert({
    required this.studentId,
    required this.studentName,
    required this.consecutiveAbsences,
  });
  final String studentId;
  final String studentName;
  final int consecutiveAbsences;
}
