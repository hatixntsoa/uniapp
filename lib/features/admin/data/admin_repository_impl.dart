import 'package:uuid/uuid.dart';

import '../domain/entities/academic_structure_entities.dart';
import '../domain/entities/admin_dashboard_stats.dart';
import '../domain/repositories/admin_repository.dart';

/// Ticket: Gp3-1 / Gp3-2 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /admin/academic-years,
/// /admin/departments, /admin/filieres, /admin/groups, /admin/dashboard
/// once backend is available. Interface stays identical.
class MockAdminRepository implements AdminRepository {
  final List<AcademicYearEntity> _years = const [
    AcademicYearEntity(id: 'ay-1', label: '2024/2025', isActive: false),
    AcademicYearEntity(id: 'ay-2', label: '2025/2026', isActive: true),
  ];

  final List<SemesterEntity> _semesters = const [
    SemesterEntity(id: 'sem-1', label: 'Semestre 1', academicYearId: 'ay-2'),
    SemesterEntity(id: 'sem-2', label: 'Semestre 2', academicYearId: 'ay-2'),
  ];

  final List<DepartmentEntity> _departments = [
    const DepartmentEntity(id: 'dep-1', name: 'Informatique'),
    const DepartmentEntity(id: 'dep-2', name: 'Mathématiques'),
  ];

  final List<FiliereEntity> _filieres = [
    const FiliereEntity(
      id: 'fil-1',
      name: 'Génie Logiciel',
      departmentId: 'dep-1',
    ),
    const FiliereEntity(id: 'fil-2', name: 'Réseaux', departmentId: 'dep-1'),
  ];

  final List<LevelEntity> _levels = const [
    LevelEntity(id: 'lvl-1', label: 'L1'),
    LevelEntity(id: 'lvl-2', label: 'L2'),
    LevelEntity(id: 'lvl-3', label: 'L3'),
    LevelEntity(id: 'lvl-4', label: 'M1'),
    LevelEntity(id: 'lvl-5', label: 'M2'),
  ];

  final List<GroupEntity> _groups = [
    const GroupEntity(
      id: 'grp-1',
      name: 'Groupe A',
      levelId: 'lvl-2',
      filiereId: 'fil-1',
      studentCount: 30,
    ),
    const GroupEntity(
      id: 'grp-2',
      name: 'Groupe B',
      levelId: 'lvl-3',
      filiereId: 'fil-1',
      studentCount: 28,
    ),
  ];

  final List<ClasseEntity> _classes = const [
    ClasseEntity(id: 'cls-1', name: 'L2 Info', groupIds: ['grp-1']),
  ];

  @override
  Future<List<AcademicYearEntity>> getAcademicYears() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_years);
  }

  @override
  Future<List<SemesterEntity>> getSemesters() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_semesters);
  }

  @override
  Future<List<DepartmentEntity>> getDepartments() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_departments);
  }

  @override
  Future<List<FiliereEntity>> getFilieres() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_filieres);
  }

  @override
  Future<List<LevelEntity>> getLevels() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_levels);
  }

  @override
  Future<List<GroupEntity>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_groups);
  }

  @override
  Future<List<ClasseEntity>> getClasses() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_classes);
  }

  @override
  Future<DepartmentEntity> createDepartment(String name) async {
    final dep = DepartmentEntity(id: const Uuid().v4(), name: name);
    _departments.add(dep);
    return dep;
  }

  @override
  Future<FiliereEntity> createFiliere(String name, String departmentId) async {
    final fil = FiliereEntity(
      id: const Uuid().v4(),
      name: name,
      departmentId: departmentId,
    );
    _filieres.add(fil);
    return fil;
  }

  @override
  Future<GroupEntity> createGroup(
    String name,
    String levelId,
    String filiereId,
  ) async {
    final grp = GroupEntity(
      id: const Uuid().v4(),
      name: name,
      levelId: levelId,
      filiereId: filiereId,
      studentCount: 0,
    );
    _groups.add(grp);
    return grp;
  }

  @override
  Future<AdminDashboardStats> getDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const AdminDashboardStats(
      studentCount: 842,
      teacherCount: 96,
      courseCount: 58,
      absenceRate: 0.12,
      evaluationCount: 134,
      equipmentCount: 210,
      alertCount: 5,
    );
  }
}
