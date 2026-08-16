/// Ticket: Gp1-3 — simple quiz builder entities (MCQ only, per spec scope)
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });

  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
}

class QuizEntity {
  const QuizEntity({required this.examId, required this.questions});

  final String examId;
  final List<QuizQuestion> questions;
}
