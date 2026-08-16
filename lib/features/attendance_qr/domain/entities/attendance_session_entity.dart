/// Ticket: Gp2-4 — attendance session for a course/group
enum SessionState { closed, open }

class AttendanceSessionEntity {
  const AttendanceSessionEntity({
    required this.id,
    required this.courseName,
    required this.groupName,
    required this.teacherName,
    required this.startTime,
    required this.state,
  });

  final String id;
  final String courseName;
  final String groupName;
  final String teacherName;
  final DateTime startTime;
  final SessionState state;

  AttendanceSessionEntity copyWith({SessionState? state}) =>
      AttendanceSessionEntity(
        id: id,
        courseName: courseName,
        groupName: groupName,
        teacherName: teacherName,
        startTime: startTime,
        state: state ?? this.state,
      );
}
