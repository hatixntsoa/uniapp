import '../entities/teacher_entity.dart';
import '../entities/teacher_schedule_entry.dart';

/// Ticket: Gp4-1..Gp4-5 — repository contract
abstract class TeacherRepository {
  Future<List<TeacherEntity>> getTeachers({
    String? query,
    String? department,
    String? subjectId,
  });
  Future<TeacherEntity> createTeacher(TeacherEntity teacher);
  Future<TeacherEntity> updateTeacher(TeacherEntity teacher);

  /// Gp4-5: teacher <-> subject linking
  Future<void> assignSubjects(String teacherId, List<String> subjectIds);

  Future<List<TeacherScheduleEntry>> getSchedule(String teacherId);
}
