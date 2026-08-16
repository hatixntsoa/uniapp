import '../domain/entities/timetable_conflict.dart';
import '../domain/entities/timetable_slot_entity.dart';
import '../domain/repositories/timetable_repository.dart';

/// Ticket: Gp9-1, Gp9-2, Gp9-3, Gp9-5 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /timetable/slots,
/// /timetable/conflicts once backend is available. Interface unchanged.
class MockTimetableRepository implements TimetableRepository {
  final List<TimetableSlotEntity> _slots = [
    const TimetableSlotEntity(
      id: 'tt-1',
      subjectName: 'Algorithmique',
      teacherName: 'Karim Haddad',
      roomName: 'Salle B12',
      groupName: 'Groupe A',
      levelLabel: 'L2',
      day: Weekday.lundi,
      start: TimeSlot(hour: 9, minute: 0),
      end: TimeSlot(hour: 10, minute: 30),
    ),
    const TimetableSlotEntity(
      id: 'tt-2',
      subjectName: 'Bases de données',
      teacherName: 'Karim Haddad',
      roomName: 'Salle A04',
      groupName: 'Groupe A',
      levelLabel: 'L2',
      day: Weekday.lundi,
      start: TimeSlot(hour: 10, minute: 0),
      end: TimeSlot(hour: 11, minute: 30),
    ),
    const TimetableSlotEntity(
      id: 'tt-3',
      subjectName: 'Analyse mathématique',
      teacherName: 'Samira Djaidja',
      roomName: 'Amphi A',
      groupName: 'Groupe B',
      levelLabel: 'L1',
      day: Weekday.mardi,
      start: TimeSlot(hour: 8, minute: 0),
      end: TimeSlot(hour: 9, minute: 30),
    ),
  ];

  @override
  Future<List<TimetableSlotEntity>> getSlots({
    String? groupName,
    String? teacherName,
    String? roomName,
    Weekday? day,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _slots.where((s) {
      if (s.isCancelled) return false;
      if (groupName != null &&
          groupName.isNotEmpty &&
          s.groupName != groupName) {
        return false;
      }
      if (teacherName != null &&
          teacherName.isNotEmpty &&
          s.teacherName != teacherName) {
        return false;
      }
      if (roomName != null && roomName.isNotEmpty && s.roomName != roomName) {
        return false;
      }
      if (day != null && s.day != day) return false;
      return true;
    }).toList()..sort((a, b) {
      final dayCompare = a.day.index.compareTo(b.day.index);
      if (dayCompare != 0) return dayCompare;
      return a.start.totalMinutes.compareTo(b.start.totalMinutes);
    });
  }

  @override
  Future<TimetableSlotEntity> createSlot(TimetableSlotEntity slot) async {
    _slots.add(slot);
    // TODO(Gp9-5): trigger auto-notification to affected group/teacher
    // once the notification channel (flutter_local_notifications) is wired.
    return slot;
  }

  @override
  Future<TimetableSlotEntity> updateSlot(TimetableSlotEntity slot) async {
    final i = _slots.indexWhere((s) => s.id == slot.id);
    if (i != -1) _slots[i] = slot;
    // TODO(Gp9-5): trigger auto-notification on change (reschedule/room change).
    return slot;
  }

  @override
  Future<void> cancelSlot(String slotId) async {
    final i = _slots.indexWhere((s) => s.id == slotId);
    if (i != -1) _slots[i] = _slots[i].copyWith(isCancelled: true);
  }

  @override
  Future<List<TimetableConflict>> detectConflicts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final conflicts = <TimetableConflict>[];
    final active = _slots.where((s) => !s.isCancelled).toList();

    for (var i = 0; i < active.length; i++) {
      for (var j = i + 1; j < active.length; j++) {
        final a = active[i];
        final b = active[j];
        if (!a.overlapsSameDay(b)) continue;

        if (a.roomName == b.roomName) {
          conflicts.add(
            TimetableConflict(type: ConflictType.room, slotA: a, slotB: b),
          );
        }
        if (a.teacherName == b.teacherName) {
          conflicts.add(
            TimetableConflict(type: ConflictType.teacher, slotA: a, slotB: b),
          );
        }
        if (a.groupName == b.groupName) {
          conflicts.add(
            TimetableConflict(type: ConflictType.group, slotA: a, slotB: b),
          );
        }
      }
    }
    return conflicts;
  }
}
