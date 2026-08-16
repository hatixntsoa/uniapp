/// Ticket: Gp3-1 — academic years, semesters, departments, filières, levels, groups, classes
class AcademicYearEntity {
  const AcademicYearEntity({
    required this.id,
    required this.label,
    required this.isActive,
  });
  final String id;
  final String label; // e.g. "2025/2026"
  final bool isActive;
}

class SemesterEntity {
  const SemesterEntity({
    required this.id,
    required this.label,
    required this.academicYearId,
  });
  final String id;
  final String label; // e.g. "Semestre 1"
  final String academicYearId;
}

class DepartmentEntity {
  const DepartmentEntity({required this.id, required this.name});
  final String id;
  final String name;
}

class FiliereEntity {
  const FiliereEntity({
    required this.id,
    required this.name,
    required this.departmentId,
  });
  final String id;
  final String name;
  final String departmentId;
}

class LevelEntity {
  const LevelEntity({
    required this.id,
    required this.label, // L1, L2, L3, M1, M2
  });
  final String id;
  final String label;
}

class GroupEntity {
  const GroupEntity({
    required this.id,
    required this.name,
    required this.levelId,
    required this.filiereId,
    required this.studentCount,
  });
  final String id;
  final String name;
  final String levelId;
  final String filiereId;
  final int studentCount;
}

class ClasseEntity {
  const ClasseEntity({
    required this.id,
    required this.name,
    required this.groupIds,
  });
  final String id;
  final String name;
  final List<String> groupIds;
}
