/// Ticket: Gp5-2 — link to evaluations/grades/timetable/groups (read-model summary)
class SubjectLinkSummary {
  const SubjectLinkSummary({
    required this.evaluationCount,
    required this.averageGrade,
    required this.timetableSlotCount,
    required this.linkedGroups,
  });

  final int evaluationCount;
  final double averageGrade;
  final int timetableSlotCount;
  final List<String> linkedGroups;
}
