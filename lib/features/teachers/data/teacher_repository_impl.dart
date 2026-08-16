import '../domain/entities/teacher_entity.dart';
import '../domain/entities/teacher_schedule_entry.dart';
import '../domain/repositories/teacher_repository.dart';

/// Ticket: Gp4-1..Gp4-5 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /teachers, /teachers/:id/schedule,
/// /teachers/:id/subjects once backend is available. Interface unchanged.
class MockTeacherRepository implements TeacherRepository {
  final List<TeacherEntity> _teachers = [
    const TeacherEntity(
      id: 'u-teach-1',
      fullName: 'Karim Haddad',
      email: 'prof@univ.fr',
      department: 'Informatique',
      status: TeacherStatus.actif,
      subjectIds: ['sub-1', 'sub-2'],
      assignedLevels: ['L2', 'L3'],
      assignedGroups: ['Groupe A'],
    ),
    const TeacherEntity(
      id: 'u-teach-2',
      fullName: 'Samira Djaidja',
      email: 'samira.djaidja@univ.fr',
      department: 'Mathématiques',
      status: TeacherStatus.actif,
      subjectIds: ['sub-3'],
      assignedLevels: ['L1'],
      assignedGroups: ['Groupe B'],
    ),
    const TeacherEntity(
      id: 'u-teach-3',
      fullName: 'Farid Boukhalfa',
      email: 'farid.boukhalfa@univ.fr',
      department: 'Informatique',
      status: TeacherStatus.conge,
      subjectIds: [],
      assignedLevels: ['M1'],
      assignedGroups: ['Groupe C'],
    ),
  ];

  @override
  Future<List<TeacherEntity>> getTeachers({
    String? query,
    String? department,
    String? subjectId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _teachers.where((t) {
      if (query != null && query.trim().isNotEmpty) {
        if (!t.fullName.toLowerCase().contains(query.toLowerCase())) {
          return false;
        }
      }
      if (department != null &&
          department.isNotEmpty &&
          t.department != department) {
        return false;
      }
      if (subjectId != null &&
          subjectId.isNotEmpty &&
          !t.subjectIds.contains(subjectId)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<TeacherEntity> createTeacher(TeacherEntity teacher) async {
    _teachers.add(teacher);
    return teacher;
  }

  @override
  Future<TeacherEntity> updateTeacher(TeacherEntity teacher) async {
    final i = _teachers.indexWhere((t) => t.id == teacher.id);
    if (i != -1) _teachers[i] = teacher;
    return teacher;
  }

  @override
  Future<void> assignSubjects(String teacherId, List<String> subjectIds) async {
    final i = _teachers.indexWhere((t) => t.id == teacherId);
    if (i != -1) {
      _teachers[i] = _teachers[i].copyWith(subjectIds: subjectIds);
    }
  }

  @override
  Future<List<TeacherScheduleEntry>> getSchedule(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return [
      TeacherScheduleEntry(
        id: 'sch-1',
        subjectName: 'Algorithmique',
        groupName: 'Groupe A',
        roomName: 'Salle B12',
        startTime: DateTime(now.year, now.month, now.day, 9, 0),
        endTime: DateTime(now.year, now.month, now.day, 10, 30),
        status: ScheduleEntryStatus.done,
      ),
      TeacherScheduleEntry(
        id: 'sch-2',
        subjectName: 'Bases de données',
        groupName: 'Groupe A',
        roomName: 'Salle A04',
        startTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 15, 30),
        status: ScheduleEntryStatus.planned,
      ),
      TeacherScheduleEntry(
        id: 'sch-3',
        subjectName: 'Algorithmique',
        groupName: 'Groupe B',
        roomName: 'Salle B12',
        startTime: DateTime(now.year, now.month, now.day - 2, 9, 0),
        endTime: DateTime(now.year, now.month, now.day - 2, 10, 30),
        status: ScheduleEntryStatus.absent,
      ),
    ];
  }
}
