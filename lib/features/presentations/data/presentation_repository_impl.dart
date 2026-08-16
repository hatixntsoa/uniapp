import '../domain/entities/presentation_entity.dart';
import '../domain/entities/presentation_evaluation.dart';
import '../domain/entities/presentation_history_entry.dart';
import '../domain/repositories/presentation_repository.dart';

/// Ticket: Gp10-1..Gp10-3 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /presentations,
/// /presentations/:id/evaluation once backend is available. Interface unchanged.
class MockPresentationRepository implements PresentationRepository {
  final List<PresentationEntity> _presentations = [
    PresentationEntity(
      id: 'pres-1',
      title: 'Projet de fin de module — Systèmes distribués',
      mode: PresentationMode.groupe,
      subjectName: 'Systèmes distribués',
      date: DateTime.now().add(const Duration(days: 4)),
      members: const [
        PresentationMember(
          studentId: 'u-stud-1',
          studentName: 'Lina Meziane',
          order: 1,
        ),
        PresentationMember(
          studentId: 'u-stud-2',
          studentName: 'Yanis Kaci',
          order: 2,
        ),
      ],
      criteria: const [
        GradingCriterion(id: 'c-1', label: 'Contenu', maxPoints: 8),
        GradingCriterion(id: 'c-2', label: 'Support visuel', maxPoints: 4),
        GradingCriterion(id: 'c-3', label: 'Aisance orale', maxPoints: 4),
        GradingCriterion(
          id: 'c-4',
          label: 'Réponses aux questions',
          maxPoints: 4,
        ),
      ],
    ),
    PresentationEntity(
      id: 'pres-2',
      title: 'Soutenance individuelle — Stage d\'initiation',
      mode: PresentationMode.individuelle,
      subjectName: 'Stage',
      date: DateTime.now().subtract(const Duration(days: 3)),
      members: const [
        PresentationMember(
          studentId: 'u-stud-3',
          studentName: 'Amel Cherif',
          order: 1,
        ),
      ],
      criteria: const [
        GradingCriterion(id: 'c-5', label: 'Rapport écrit', maxPoints: 10),
        GradingCriterion(id: 'c-6', label: 'Soutenance orale', maxPoints: 10),
      ],
      isCompleted: true,
    ),
  ];

  final Map<String, PresentationEvaluation> _evaluations = {
    'pres-2': const PresentationEvaluation(
      presentationId: 'pres-2',
      collectiveScore: 0,
      memberEvaluations: [
        MemberEvaluation(
          studentId: 'u-stud-3',
          studentName: 'Amel Cherif',
          attendance: PresentationAttendance.present,
          individualScores: [
            CriterionScore(criterionId: 'c-5', points: 8.5),
            CriterionScore(criterionId: 'c-6', points: 9),
          ],
          remarks: 'Bonne maîtrise du sujet, présentation claire.',
          hasSupportFile: true,
        ),
      ],
    ),
  };

  @override
  Future<List<PresentationEntity>> getPresentations() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_presentations);
  }

  @override
  Future<PresentationEntity> createPresentation(
    PresentationEntity presentation,
  ) async {
    _presentations.add(presentation);
    return presentation;
  }

  @override
  Future<PresentationEvaluation> getEvaluation(String presentationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final existing = _evaluations[presentationId];
    if (existing != null) return existing;

    final presentation = _presentations.firstWhere(
      (p) => p.id == presentationId,
    );
    return PresentationEvaluation(
      presentationId: presentationId,
      collectiveScore: 0,
      memberEvaluations: [
        for (final m in presentation.members)
          MemberEvaluation(
            studentId: m.studentId,
            studentName: m.studentName,
            attendance: PresentationAttendance.present,
            individualScores: [
              for (final c in presentation.criteria)
                CriterionScore(criterionId: c.id, points: 0),
            ],
          ),
      ],
    );
  }

  @override
  Future<void> saveEvaluation(PresentationEvaluation evaluation) async {
    _evaluations[evaluation.presentationId] = evaluation;
  }

  @override
  Future<void> markCompleted(String presentationId) async {
    final i = _presentations.indexWhere((p) => p.id == presentationId);
    if (i != -1) {
      _presentations[i] = _presentations[i].copyWith(isCompleted: true);
    }
  }

  @override
  Future<List<PresentationHistoryEntry>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _presentations.map((p) {
      final eval = _evaluations[p.id];
      double? finalScore;
      if (eval != null && eval.memberEvaluations.isNotEmpty) {
        final total = eval.memberEvaluations
            .map((m) => m.individualTotal + eval.collectiveScore)
            .reduce((a, b) => a + b);
        finalScore = total / eval.memberEvaluations.length;
      }
      return PresentationHistoryEntry(
        presentationId: p.id,
        title: p.title,
        date: p.date,
        status: p.isCompleted
            ? PresentationStatus.evaluee
            : (p.date.isBefore(DateTime.now())
                  ? PresentationStatus.enCours
                  : PresentationStatus.planifiee),
        finalScore: finalScore,
      );
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
