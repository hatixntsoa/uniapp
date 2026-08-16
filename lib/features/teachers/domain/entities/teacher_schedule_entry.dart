/// Ticket: Gp4-3 — schedule view (EDT) with sessions + absences
enum ScheduleEntryStatus { planned, done, absent }

extension ScheduleEntryStatusX on ScheduleEntryStatus {
  String get label => switch (this) {
    ScheduleEntryStatus.planned => 'Planifiée',
    ScheduleEntryStatus.done => 'Effectuée',
    ScheduleEntryStatus.absent => 'Absence',
  };
}

class TeacherScheduleEntry {
  const TeacherScheduleEntry({
    required this.id,
    required this.subjectName,
    required this.groupName,
    required this.roomName,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  final String id;
  final String subjectName;
  final String groupName;
  final String roomName;
  final DateTime startTime;
  final DateTime endTime;
  final ScheduleEntryStatus status;
}
