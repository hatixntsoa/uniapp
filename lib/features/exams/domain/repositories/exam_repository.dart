import '../entities/exam_entity.dart';
import '../entities/grade_entity.dart';
import '../entities/quiz_entity.dart';

/// Ticket: Gp1-1..Gp1-5 — repository contract.
/// Swapping mock -> real API means implementing this interface with a
/// Dio-backed class; no callers change.
abstract class ExamRepository {
  Future<List<ExamEntity>> getExams();
  Future<ExamEntity> createExam(ExamEntity exam);
  Future<ExamEntity> updateExam(ExamEntity exam);
  Future<void> deleteExam(String examId);
  Future<void> publishExam(String examId);

  Future<List<GradeEntity>> getRoster(String examId);
  Future<void> updateGrade(String examId, GradeEntity grade);

  Future<QuizEntity?> getQuiz(String examId);
  Future<void> saveQuiz(QuizEntity quiz);

  /// Gp1-5: auto-grade MCQ answers against the quiz's correct options.
  Future<double> autoGradeMcq(QuizEntity quiz, Map<String, int> studentAnswers);
}
