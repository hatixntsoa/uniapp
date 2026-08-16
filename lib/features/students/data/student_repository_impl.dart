import '../domain/entities/academic_history_entry.dart';
import '../domain/entities/student_entity.dart';
import '../domain/entities/student_situation.dart';
import '../domain/repositories/student_repository.dart';

/// Ticket: Gp2-1..Gp2-3 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to GET/POST/PUT /students and
/// GET /students/:id/history, /students/:id/situation once the backend
/// contract is available. Interface stays identical.
class MockStudentRepository implements StudentRepository {
  final List<StudentEntity> _students = [
    const StudentEntity(
      id: 'u-stud-1',
      fullName: 'Lina Meziane',
      matricule: '20231045',
      email: 'lina.meziane@etu.univ.fr',
      filiere: 'Informatique',
      niveau: 'L2',
      groupName: 'Groupe A',
      anneeUniversitaire: '2025/2026',
    ),
    const StudentEntity(
      id: 'u-stud-2',
      fullName: 'Yanis Kaci',
      matricule: '20231046',
      email: 'yanis.kaci@etu.univ.fr',
      filiere: 'Informatique',
      niveau: 'L2',
      groupName: 'Groupe A',
      anneeUniversitaire: '2025/2026',
    ),
    const StudentEntity(
      id: 'u-stud-3',
      fullName: 'Amel Cherif',
      matricule: '20231047',
      email: 'amel.cherif@etu.univ.fr',
      filiere: 'Génie Logiciel',
      niveau: 'L3',
      groupName: 'Groupe B',
      anneeUniversitaire: '2025/2026',
    ),
    const StudentEntity(
      id: 'u-stud-4',
      fullName: 'Sofiane Belkacem',
      matricule: '20231048',
      email: 'sofiane.belkacem@etu.univ.fr',
      filiere: 'Réseaux',
      niveau: 'M1',
      groupName: 'Groupe C',
      anneeUniversitaire: '2025/2026',
    ),
  ];

  @override
  Future<List<StudentEntity>> getStudents({
    String? query,
    String? niveau,
    String? groupName,
    bool includeArchived = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _students.where((s) {
      if (!includeArchived && s.isArchived) return false;
      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase();
        if (!s.fullName.toLowerCase().contains(q) && !s.matricule.contains(q)) {
          return false;
        }
      }
      if (niveau != null && niveau.isNotEmpty && s.niveau != niveau) {
        return false;
      }
      if (groupName != null &&
          groupName.isNotEmpty &&
          s.groupName != groupName) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<StudentEntity> createStudent(StudentEntity student) async {
    _students.add(student);
    return student;
  }

  @override
  Future<StudentEntity> updateStudent(StudentEntity student) async {
    final i = _students.indexWhere((s) => s.id == student.id);
    if (i != -1) _students[i] = student;
    return student;
  }

  @override
  Future<void> archiveStudent(String studentId) async {
    final i = _students.indexWhere((s) => s.id == studentId);
    if (i != -1) _students[i] = _students[i].copyWith(isArchived: true);
  }

  @override
  Future<List<AcademicHistoryEntry>> getAcademicHistory(
    String studentId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      AcademicHistoryEntry(
        title: 'Inscription L2 Informatique',
        subtitle: 'Groupe A · Année 2025/2026',
        date: DateTime(2025, 9, 15),
        details: const ['Filière: Informatique', 'Niveau: L2'],
      ),
      AcademicHistoryEntry(
        title: 'Contrôle continu — Algorithmique',
        subtitle: 'Note obtenue: 15,5/20',
        date: DateTime.now().subtract(const Duration(days: 20)),
        details: const ['Présence: Présent', 'Coefficient: 1.5'],
      ),
      AcademicHistoryEntry(
        title: 'Absence — Bases de données',
        subtitle: 'Statut: Justifiée',
        date: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];
  }

  @override
  Future<StudentSituation> getSituation(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final student = _students.firstWhere((s) => s.id == studentId);
    return StudentSituation(
      student: student,
      grades: const [
        GradeSummary(
          subjectName: 'Algorithmique',
          grade: 15.5,
          coefficient: 1.5,
        ),
        GradeSummary(
          subjectName: 'Bases de données',
          grade: 12,
          coefficient: 3,
        ),
      ],
      absenceCount: 3,
      justifiedAbsenceCount: 1,
      upcomingExams: [
        UpcomingExamSummary(
          title: 'Examen final — Bases de données',
          date: DateTime.now().add(const Duration(days: 10)),
          subjectName: 'Bases de données',
        ),
      ],
      notificationCount: 2,
    );
  }
}
