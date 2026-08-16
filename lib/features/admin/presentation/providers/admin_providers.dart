import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/admin_repository_impl.dart';
import '../../domain/entities/academic_structure_entities.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/repositories/admin_repository.dart';

/// Ticket: Gp3-1 / Gp3-2 — providers
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return MockAdminRepository();
});

final academicYearsProvider = FutureProvider<List<AcademicYearEntity>>((ref) {
  return ref.read(adminRepositoryProvider).getAcademicYears();
});

final semestersProvider = FutureProvider<List<SemesterEntity>>((ref) {
  return ref.read(adminRepositoryProvider).getSemesters();
});

final departmentsProvider =
    AsyncNotifierProvider<DepartmentsNotifier, List<DepartmentEntity>>(
      DepartmentsNotifier.new,
    );

class DepartmentsNotifier extends AsyncNotifier<List<DepartmentEntity>> {
  @override
  Future<List<DepartmentEntity>> build() {
    return ref.read(adminRepositoryProvider).getDepartments();
  }

  Future<void> add(String name) async {
    await ref.read(adminRepositoryProvider).createDepartment(name);
    ref.invalidateSelf();
  }
}

final filieresProvider =
    AsyncNotifierProvider<FilieresNotifier, List<FiliereEntity>>(
      FilieresNotifier.new,
    );

class FilieresNotifier extends AsyncNotifier<List<FiliereEntity>> {
  @override
  Future<List<FiliereEntity>> build() {
    return ref.read(adminRepositoryProvider).getFilieres();
  }

  Future<void> add(String name, String departmentId) async {
    await ref.read(adminRepositoryProvider).createFiliere(name, departmentId);
    ref.invalidateSelf();
  }
}

final levelsProvider = FutureProvider<List<LevelEntity>>((ref) {
  return ref.read(adminRepositoryProvider).getLevels();
});

final groupsProvider = AsyncNotifierProvider<GroupsNotifier, List<GroupEntity>>(
  GroupsNotifier.new,
);

class GroupsNotifier extends AsyncNotifier<List<GroupEntity>> {
  @override
  Future<List<GroupEntity>> build() {
    return ref.read(adminRepositoryProvider).getGroups();
  }

  Future<void> add(String name, String levelId, String filiereId) async {
    await ref
        .read(adminRepositoryProvider)
        .createGroup(name, levelId, filiereId);
    ref.invalidateSelf();
  }
}

final classesProvider = FutureProvider<List<ClasseEntity>>((ref) {
  return ref.read(adminRepositoryProvider).getClasses();
});

final dashboardStatsProvider = FutureProvider<AdminDashboardStats>((ref) {
  return ref.read(adminRepositoryProvider).getDashboardStats();
});
