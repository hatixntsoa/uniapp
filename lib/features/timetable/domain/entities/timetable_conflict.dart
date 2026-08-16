import 'timetable_slot_entity.dart';

/// Ticket: Gp9-3 — conflict detection (room/teacher/group double-booked)
enum ConflictType { room, teacher, group }

extension ConflictTypeX on ConflictType {
  String get label => switch (this) {
    ConflictType.room => 'Salle double-réservée',
    ConflictType.teacher => 'Enseignant en double',
    ConflictType.group => 'Groupe en double',
  };
}

class TimetableConflict {
  const TimetableConflict({
    required this.type,
    required this.slotA,
    required this.slotB,
  });

  final ConflictType type;
  final TimetableSlotEntity slotA;
  final TimetableSlotEntity slotB;
}
