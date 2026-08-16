/// Ticket: Gp2-4 — per-student check-in record within a session
enum CheckInStatus { present, absent, late, justified }

extension CheckInStatusX on CheckInStatus {
  String get label => switch (this) {
    CheckInStatus.present => 'Présent',
    CheckInStatus.absent => 'Absent',
    CheckInStatus.late => 'Retard',
    CheckInStatus.justified => 'Justifié',
  };
}

class AttendanceRecordEntity {
  const AttendanceRecordEntity({
    required this.studentId,
    required this.studentName,
    required this.status,
    this.checkedInAt,
  });

  final String studentId;
  final String studentName;
  final CheckInStatus status;
  final DateTime? checkedInAt;

  AttendanceRecordEntity copyWith({
    CheckInStatus? status,
    DateTime? checkedInAt,
  }) => AttendanceRecordEntity(
    studentId: studentId,
    studentName: studentName,
    status: status ?? this.status,
    checkedInAt: checkedInAt ?? this.checkedInAt,
  );
}
