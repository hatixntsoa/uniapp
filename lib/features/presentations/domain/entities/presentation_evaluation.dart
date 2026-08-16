/// Ticket: Gp10-2 — per-student remarks/comments/attendance/support file;
/// distinguish collective vs individual grade
enum PresentationAttendance { present, absent }

class CriterionScore {
  const CriterionScore({required this.criterionId, required this.points});
  final String criterionId;
  final double points;
}

class MemberEvaluation {
  const MemberEvaluation({
    required this.studentId,
    required this.studentName,
    required this.attendance,
    required this.individualScores,
    this.remarks = '',
    this.hasSupportFile = false,
  });

  final String studentId;
  final String studentName;
  final PresentationAttendance attendance;
  final List<CriterionScore> individualScores;
  final String remarks;
  final bool hasSupportFile;

  double get individualTotal =>
      individualScores.fold(0, (sum, s) => sum + s.points);

  MemberEvaluation copyWith({
    PresentationAttendance? attendance,
    List<CriterionScore>? individualScores,
    String? remarks,
    bool? hasSupportFile,
  }) => MemberEvaluation(
    studentId: studentId,
    studentName: studentName,
    attendance: attendance ?? this.attendance,
    individualScores: individualScores ?? this.individualScores,
    remarks: remarks ?? this.remarks,
    hasSupportFile: hasSupportFile ?? this.hasSupportFile,
  );
}

/// Collective grade applies to the whole group; individual scores layer on top.
class PresentationEvaluation {
  const PresentationEvaluation({
    required this.presentationId,
    required this.collectiveScore,
    required this.memberEvaluations,
  });

  final String presentationId;
  final double collectiveScore;
  final List<MemberEvaluation> memberEvaluations;
}
