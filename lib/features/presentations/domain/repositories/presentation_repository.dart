import '../entities/presentation_entity.dart';
import '../entities/presentation_evaluation.dart';
import '../entities/presentation_history_entry.dart';

/// Ticket: Gp10-1..Gp10-3 — repository contract
abstract class PresentationRepository {
  Future<List<PresentationEntity>> getPresentations();
  Future<PresentationEntity> createPresentation(
    PresentationEntity presentation,
  );

  Future<PresentationEvaluation> getEvaluation(String presentationId);
  Future<void> saveEvaluation(PresentationEvaluation evaluation);
  Future<void> markCompleted(String presentationId);

  Future<List<PresentationHistoryEntry>> getHistory();
}
