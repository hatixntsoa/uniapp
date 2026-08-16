import '../domain/entities/exam_entity.dart';
import '../domain/entities/grade_entity.dart';
import '../domain/entities/quiz_entity.dart';
import '../domain/repositories/exam_repository.dart';
import 'ai_grading_service.dart';

/// Ticket: Gp1-1..Gp1-4 — mock in-memory implementation.
/// Status: mocked. Replace the in-memory lists with Dio calls to
/// GET/POST/PUT/DELETE /exams once the backend is available; the
/// interface (ExamRepository) does not need to change.
class MockExamRepository implements ExamRepository {
  MockExamRepository({AiGradingService? aiGradingService})
      : _ai = aiGradingService ?? AiGradingService();

  final AiGradingService _ai;

  final List<ExamEntity> _exams = [
    ExamEntity(
      id: 'ex-1',
      title: 'Contrôle continu — Algorithmique',
      type: ExamType.continueEval,
      subjectId: 'sub-1',
      subjectName: 'Algorithmique',
      teacherId: 'u-teach-1',
      teacherName: 'Karim Haddad',
      groupId: 'grp-1',
      groupName: 'L2 Info — Groupe A',
      date: DateTime.now().add(const Duration(days: 3)),
      durationMinutes: 60,
      bareme: 20,
      coefficient: 1.5,
    ),
    ExamEntity(
      id: 'ex-2',
      title: 'Examen final — Bases de données',
      type: ExamType.examenFinal,
      subjectId: 'sub-2',
      subjectName: 'Bases de données',
      teacherId: 'u-teach-1',
      teacherName: 'Karim Haddad',
      groupId: 'grp-1',
      groupName: 'L2 Info — Groupe A',
      date: DateTime.now().add(const Duration(days: 10)),
      durationMinutes: 120,
      bareme: 20,
      coefficient: 3,
    ),
  ];

  final Map<String, List<GradeEntity>> _rosters = {
    'ex-1': [
      const GradeEntity(
        studentId: 'u-stud-1',
        studentName: 'Lina Meziane',
        attendance: ExamAttendanceStatus.present,
        grade: 15.5,
      ),
      const GradeEntity(
        studentId: 'u-stud-2',
        studentName: 'Yanis Kaci',
        attendance: ExamAttendanceStatus.absent,
      ),
      const GradeEntity(
        studentId: 'u-stud-3',
        studentName: 'Amel Cherif',
        attendance: ExamAttendanceStatus.late,
        grade: 12,
      ),
    ],
    'ex-2': [],
  };

  final Map<String, QuizEntity> _quizzes = {};

  @override
  Future<List<ExamEntity>> getExams() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_exams);
  }

  @override
  Future<ExamEntity> createExam(ExamEntity exam) async {
    _exams.add(exam);
    _rosters.putIfAbsent(exam.id, () => []);
    return exam;
  }

  @override
  Future<ExamEntity> updateExam(ExamEntity exam) async {
    final i = _exams.indexWhere((e) => e.id == exam.id);
    if (i != -1) _exams[i] = exam;
    return exam;
  }

  @override
  Future<void> deleteExam(String examId) async {
    _exams.removeWhere((e) => e.id == examId);
    _rosters.remove(examId);
  }

  @override
  Future<void> publishExam(String examId) async {
    final i = _exams.indexWhere((e) => e.id == examId);
    if (i != -1) _exams[i] = _exams[i].copyWith(isPublished: true);
  }

  @override
  Future<List<GradeEntity>> getRoster(String examId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_rosters[examId] ?? const []);
  }

  @override
  Future<void> updateGrade(String examId, GradeEntity grade) async {
    final roster = _rosters.putIfAbsent(examId, () => []);
    final i = roster.indexWhere((g) => g.studentId == grade.studentId);
    if (i != -1) {
      roster[i] = grade;
    } else {
      roster.add(grade);
    }
  }

  @override
  Future<QuizEntity?> getQuiz(String examId) async => _quizzes[examId];

  @override
  Future<void> saveQuiz(QuizEntity quiz) async {
    _quizzes[quiz.examId] = quiz;
  }

  @override
  Future<double> autoGradeMcq(
    QuizEntity quiz,
    Map<String, int> studentAnswers,
  ) {
    return _ai.gradeMcq(quiz, studentAnswers);
  }
}