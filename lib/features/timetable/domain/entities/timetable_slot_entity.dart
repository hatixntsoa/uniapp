/// Ticket: Gp9-1/9-2 — timetable slot (subject/teacher/room/day/time)
enum Weekday { lundi, mardi, mercredi, jeudi, vendredi, samedi }

extension WeekdayX on Weekday {
  String get label => switch (this) {
    Weekday.lundi => 'Lundi',
    Weekday.mardi => 'Mardi',
    Weekday.mercredi => 'Mercredi',
    Weekday.jeudi => 'Jeudi',
    Weekday.vendredi => 'Vendredi',
    Weekday.samedi => 'Samedi',
  };
}

class TimeSlot {
  const TimeSlot({required this.hour, required this.minute});
  final int hour;
  final int minute;

  String get label =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  int get totalMinutes => hour * 60 + minute;
}

class TimetableSlotEntity {
  const TimetableSlotEntity({
    required this.id,
    required this.subjectName,
    required this.teacherName,
    required this.roomName,
    required this.groupName,
    required this.levelLabel,
    required this.day,
    required this.start,
    required this.end,
    this.isCancelled = false,
  });

  final String id;
  final String subjectName;
  final String teacherName;
  final String roomName;
  final String groupName;
  final String levelLabel;
  final Weekday day;
  final TimeSlot start;
  final TimeSlot end;
  final bool isCancelled;

  TimetableSlotEntity copyWith({
    String? roomName,
    Weekday? day,
    TimeSlot? start,
    TimeSlot? end,
    bool? isCancelled,
  }) => TimetableSlotEntity(
    id: id,
    subjectName: subjectName,
    teacherName: teacherName,
    roomName: roomName ?? this.roomName,
    groupName: groupName,
    levelLabel: levelLabel,
    day: day ?? this.day,
    start: start ?? this.start,
    end: end ?? this.end,
    isCancelled: isCancelled ?? this.isCancelled,
  );

  bool overlapsSameDay(TimetableSlotEntity other) {
    if (day != other.day) return false;
    return start.totalMinutes < other.end.totalMinutes &&
        end.totalMinutes > other.start.totalMinutes;
  }
}
