import '../domain/entities/subject_entity.dart';
import '../domain/entities/subject_links.dart';
import '../domain/repositories/subject_repository.dart';

/// Ticket: Gp5-1..Gp5-3 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /subjects, /subjects/:id/links
/// once backend is available. Interface unchanged.
class MockSubjectRepository implements SubjectRepository {
  final List<SubjectEntity> _subjects = [
    const SubjectEntity(
      id: 'sub-1',
      code: 'INF201',
      name: 'Algorithmique',
      coefficient: 1.5,
      volumeHoraire: 45,
      semestre: 'Semestre 1',
      niveau: 'L2',
      filiere: 'Génie Logiciel',
      teacherId: 'u-teach-1',
      teacherName: 'Karim Haddad',
    ),
    const SubjectEntity(
      id: 'sub-2',
      code: 'INF204',
      name: 'Bases de données',
      coefficient: 3,
      volumeHoraire: 60,
      semestre: 'Semestre 1',
      niveau: 'L2',
      filiere: 'Génie Logiciel',
      teacherId: 'u-teach-1',
      teacherName: 'Karim Haddad',
    ),
    const SubjectEntity(
      id: 'sub-3',
      code: 'MAT101',
      name: 'Analyse mathématique',
      coefficient: 2,
      volumeHoraire: 40,
      semestre: 'Semestre 1',
      niveau: 'L1',
      filiere: 'Informatique',
      teacherId: 'u-teach-2',
      teacherName: 'Samira Djaidja',
    ),
  ];

  @override
  Future<List<SubjectEntity>> getSubjects({
    String? query,
    String? niveau,
    String? filiere,
    String? teacherId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _subjects.where((s) {
      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase();
        if (!s.name.toLowerCase().contains(q) &&
            !s.code.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (niveau != null && niveau.isNotEmpty && s.niveau != niveau) {
        return false;
      }
      if (filiere != null && filiere.isNotEmpty && s.filiere != filiere) {
        return false;
      }
      if (teacherId != null &&
          teacherId.isNotEmpty &&
          s.teacherId != teacherId) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<SubjectEntity> createSubject(SubjectEntity subject) async {
    _subjects.add(subject);
    return subject;
  }

  @override
  Future<SubjectEntity> updateSubject(SubjectEntity subject) async {
    final i = _subjects.indexWhere((s) => s.id == subject.id);
    if (i != -1) _subjects[i] = subject;
    return subject;
  }

  @override
  Future<void> deleteSubject(String subjectId) async {
    _subjects.removeWhere((s) => s.id == subjectId);
  }

  @override
  Future<SubjectLinkSummary> getLinkSummary(String subjectId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Mocked: fixed aggregate; a real implementation would join against
    // features/exams, features/timetable, and features/admin group data.
    return const SubjectLinkSummary(
      evaluationCount: 3,
      averageGrade: 13.8,
      timetableSlotCount: 2,
      linkedGroups: ['Groupe A', 'Groupe B'],
    );
  }
}
