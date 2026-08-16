import '../entities/timetable_conflict.dart';
import '../entities/timetable_slot_entity.dart';

/// Ticket: Gp9-1, Gp9-2, Gp9-3, Gp9-5 — repository contract
abstract class TimetableRepository {
  /// Gp9-5: multi-view consultation (student/teacher/group/room/day)
  Future<List<TimetableSlotEntity>> getSlots({
    String? groupName,
    String? teacherName,
    String? roomName,
    Weekday? day,
  });

  Future<TimetableSlotEntity> createSlot(TimetableSlotEntity slot);
  Future<TimetableSlotEntity> updateSlot(TimetableSlotEntity slot);
  Future<void> cancelSlot(String slotId);

  /// Gp9-3: detect room/teacher/group double-booking across all slots.
  Future<List<TimetableConflict>> detectConflicts();
}
