import '../entities/academic_structure_entities.dart';
import '../entities/admin_dashboard_stats.dart';

/// Ticket: Gp3-1 / Gp3-2 — repository contract
abstract class AdminRepository {
  Future<List<AcademicYearEntity>> getAcademicYears();
  Future<List<SemesterEntity>> getSemesters();
  Future<List<DepartmentEntity>> getDepartments();
  Future<List<FiliereEntity>> getFilieres();
  Future<List<LevelEntity>> getLevels();
  Future<List<GroupEntity>> getGroups();
  Future<List<ClasseEntity>> getClasses();

  Future<DepartmentEntity> createDepartment(String name);
  Future<FiliereEntity> createFiliere(String name, String departmentId);
  Future<GroupEntity> createGroup(
    String name,
    String levelId,
    String filiereId,
  );

  Future<AdminDashboardStats> getDashboardStats();
}
