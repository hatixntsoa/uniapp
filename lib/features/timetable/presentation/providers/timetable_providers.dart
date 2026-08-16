import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/timetable_repository_impl.dart';
import '../../domain/entities/timetable_conflict.dart';
import '../../domain/entities/timetable_slot_entity.dart';
import '../../domain/repositories/timetable_repository.dart';

/// Ticket: Gp9-1, Gp9-2, Gp9-3, Gp9-5 — providers
final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return MockTimetableRepository();
});

/// Gp9-5: multi-view filter (student/teacher/group/room/day)
class TimetableViewFilter {
  const TimetableViewFilter({
    this.groupName,
    this.teacherName,
    this.roomName,
    this.day,
  });
  final String? groupName;
  final String? teacherName;
  final String? roomName;
  final Weekday? day;

  TimetableViewFilter copyWith({
    String? groupName,
    String? teacherName,
    String? roomName,
    Weekday? day,
  }) => TimetableViewFilter(
    groupName: groupName ?? this.groupName,
    teacherName: teacherName ?? this.teacherName,
    roomName: roomName ?? this.roomName,
    day: day ?? this.day,
  );
}

final timetableViewFilterProvider = StateProvider<TimetableViewFilter>((ref) {
  return const TimetableViewFilter();
});

final timetableSlotsProvider =
    AsyncNotifierProvider<TimetableSlotsNotifier, List<TimetableSlotEntity>>(
      TimetableSlotsNotifier.new,
    );

class TimetableSlotsNotifier extends AsyncNotifier<List<TimetableSlotEntity>> {
  @override
  Future<List<TimetableSlotEntity>> build() {
    final filter = ref.watch(timetableViewFilterProvider);
    return ref
        .read(timetableRepositoryProvider)
        .getSlots(
          groupName: filter.groupName,
          teacherName: filter.teacherName,
          roomName: filter.roomName,
          day: filter.day,
        );
  }

  Future<void> createSlot(TimetableSlotEntity slot) async {
    await ref.read(timetableRepositoryProvider).createSlot(slot);
    ref.invalidateSelf();
  }

  Future<void> cancelSlot(String id) async {
    await ref.read(timetableRepositoryProvider).cancelSlot(id);
    ref.invalidateSelf();
  }
}

final timetableConflictsProvider = FutureProvider<List<TimetableConflict>>((
  ref,
) {
  ref.watch(timetableSlotsProvider);
  return ref.read(timetableRepositoryProvider).detectConflicts();
});
