import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/teacher_repository_impl.dart';
import '../../domain/entities/teacher_entity.dart';
import '../../domain/entities/teacher_schedule_entry.dart';
import '../../domain/repositories/teacher_repository.dart';

/// Ticket: Gp4-1..Gp4-5 — providers
final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return MockTeacherRepository();
});

class TeacherFilter {
  const TeacherFilter({this.query = '', this.department});
  final String query;
  final String? department;

  TeacherFilter copyWith({String? query, String? department}) => TeacherFilter(
    query: query ?? this.query,
    department: department ?? this.department,
  );
}

final teacherFilterProvider = StateProvider<TeacherFilter>((ref) {
  return const TeacherFilter();
});

final teacherListProvider =
    AsyncNotifierProvider<TeacherListNotifier, List<TeacherEntity>>(
      TeacherListNotifier.new,
    );

class TeacherListNotifier extends AsyncNotifier<List<TeacherEntity>> {
  @override
  Future<List<TeacherEntity>> build() {
    final filter = ref.watch(teacherFilterProvider);
    return ref
        .read(teacherRepositoryProvider)
        .getTeachers(query: filter.query, department: filter.department);
  }

  Future<void> createTeacher(TeacherEntity teacher) async {
    await ref.read(teacherRepositoryProvider).createTeacher(teacher);
    ref.invalidateSelf();
  }

  Future<void> assignSubjects(String teacherId, List<String> subjectIds) async {
    await ref
        .read(teacherRepositoryProvider)
        .assignSubjects(teacherId, subjectIds);
    ref.invalidateSelf();
  }
}

final teacherScheduleProvider =
    FutureProvider.family<List<TeacherScheduleEntry>, String>((ref, teacherId) {
      return ref.read(teacherRepositoryProvider).getSchedule(teacherId);
    });
