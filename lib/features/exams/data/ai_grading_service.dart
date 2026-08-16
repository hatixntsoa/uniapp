import '../domain/entities/quiz_entity.dart';

/// Ticket: Gp1-5 — pluggable AI grading service.
/// Status: stubbed. MCQ scoring is deterministic (no AI needed) and fully
/// functional today. The open-question similarity/plagiarism check is a
/// stub — swap `flagPlagiarism` for a real embedding-similarity call
/// (e.g. Anthropic API) once a grading backend is chosen; the call site
/// in ExamRepository does not need to change.
class AiGradingService {
  /// Fully functional: score = (correct answers / total questions) * barème(20).
  Future<double> gradeMcq(
    QuizEntity quiz,
    Map<String, int> studentAnswers,
  ) async {
    if (quiz.questions.isEmpty) return 0;
    var correct = 0;
    for (final q in quiz.questions) {
      if (studentAnswers[q.id] == q.correctOptionIndex) correct++;
    }
    return (correct / quiz.questions.length) * 20;
  }

  /// TODO(Gp1-5): stub — always returns false + null score until a real
  /// similarity/plagiarism model is plugged in behind this interface.
  Future<({bool flagged, double? similarityScore})> flagPlagiarism(
    String studentAnswerText,
    List<String> corpusToCompareAgainst,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return (flagged: false, similarityScore: null);
  }
}
