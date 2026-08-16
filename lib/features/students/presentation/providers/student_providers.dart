import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/student_repository_impl.dart';
import '../../domain/entities/academic_history_entry.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/entities/student_situation.dart';
import '../../domain/repositories/student_repository.dart';

/// Ticket: Gp2-1..Gp2-3 — providers
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return MockStudentRepository();
});

class StudentFilter {
  const StudentFilter({this.query = '', this.niveau, this.groupName});
  final String query;
  final String? niveau;
  final String? groupName;

  StudentFilter copyWith({String? query, String? niveau, String? groupName}) {
    return StudentFilter(
      query: query ?? this.query,
      niveau: niveau ?? this.niveau,
      groupName: groupName ?? this.groupName,
    );
  }
}

final studentFilterProvider = StateProvider<StudentFilter>((ref) {
  return const StudentFilter();
});

final studentListProvider =
    AsyncNotifierProvider<StudentListNotifier, List<StudentEntity>>(
      StudentListNotifier.new,
    );

class StudentListNotifier extends AsyncNotifier<List<StudentEntity>> {
  @override
  Future<List<StudentEntity>> build() {
    final filter = ref.watch(studentFilterProvider);
    return ref
        .read(studentRepositoryProvider)
        .getStudents(
          query: filter.query,
          niveau: filter.niveau,
          groupName: filter.groupName,
        );
  }

  Future<void> createStudent(StudentEntity student) async {
    await ref.read(studentRepositoryProvider).createStudent(student);
    ref.invalidateSelf();
  }

  Future<void> archiveStudent(String id) async {
    await ref.read(studentRepositoryProvider).archiveStudent(id);
    ref.invalidateSelf();
  }
}

final studentHistoryProvider =
    FutureProvider.family<List<AcademicHistoryEntry>, String>((ref, id) {
      return ref.read(studentRepositoryProvider).getAcademicHistory(id);
    });

final studentSituationProvider =
    FutureProvider.family<StudentSituation, String>((ref, id) {
      return ref.read(studentRepositoryProvider).getSituation(id);
    });
