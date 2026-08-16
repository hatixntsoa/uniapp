import '../entities/subject_entity.dart';
import '../entities/subject_links.dart';

/// Ticket: Gp5-1..Gp5-3 — repository contract
abstract class SubjectRepository {
  Future<List<SubjectEntity>> getSubjects({
    String? query,
    String? niveau,
    String? filiere,
    String? teacherId,
  });
  Future<SubjectEntity> createSubject(SubjectEntity subject);
  Future<SubjectEntity> updateSubject(SubjectEntity subject);
  Future<void> deleteSubject(String subjectId);

  Future<SubjectLinkSummary> getLinkSummary(String subjectId);
}
