import '../entities/academic_history_entry.dart';
import '../entities/student_entity.dart';
import '../entities/student_situation.dart';

/// Ticket: Gp2-1..Gp2-3 — repository contract.
abstract class StudentRepository {
  Future<List<StudentEntity>> getStudents({
    String? query,
    String? niveau,
    String? groupName,
    bool includeArchived,
  });
  Future<StudentEntity> createStudent(StudentEntity student);
  Future<StudentEntity> updateStudent(StudentEntity student);
  Future<void> archiveStudent(String studentId);

  Future<List<AcademicHistoryEntry>> getAcademicHistory(String studentId);
  Future<StudentSituation> getSituation(String studentId);
}
