import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/presentation_repository_impl.dart';
import '../../domain/entities/presentation_entity.dart';
import '../../domain/entities/presentation_evaluation.dart';
import '../../domain/entities/presentation_history_entry.dart';
import '../../domain/repositories/presentation_repository.dart';

/// Ticket: Gp10-1..Gp10-3 — providers
final presentationRepositoryProvider = Provider<PresentationRepository>((ref) {
  return MockPresentationRepository();
});

final presentationListProvider =
    AsyncNotifierProvider<PresentationListNotifier, List<PresentationEntity>>(
      PresentationListNotifier.new,
    );

class PresentationListNotifier extends AsyncNotifier<List<PresentationEntity>> {
  @override
  Future<List<PresentationEntity>> build() {
    return ref.read(presentationRepositoryProvider).getPresentations();
  }

  Future<void> createPresentation(PresentationEntity presentation) async {
    await ref
        .read(presentationRepositoryProvider)
        .createPresentation(presentation);
    ref.invalidateSelf();
  }

  Future<void> markCompleted(String id) async {
    await ref.read(presentationRepositoryProvider).markCompleted(id);
    ref.invalidateSelf();
  }
}

final presentationEvaluationProvider =
    AsyncNotifierProvider.family<
      PresentationEvaluationNotifier,
      PresentationEvaluation,
      String
    >(PresentationEvaluationNotifier.new);

class PresentationEvaluationNotifier
    extends FamilyAsyncNotifier<PresentationEvaluation, String> {
  @override
  Future<PresentationEvaluation> build(String presentationId) {
    return ref
        .read(presentationRepositoryProvider)
        .getEvaluation(presentationId);
  }

  Future<void> updateMember(MemberEvaluation updated) async {
    final current = state.value;
    if (current == null) return;
    final members = [
      for (final m in current.memberEvaluations)
        if (m.studentId == updated.studentId) updated else m,
    ];
    final next = PresentationEvaluation(
      presentationId: current.presentationId,
      collectiveScore: current.collectiveScore,
      memberEvaluations: members,
    );
    state = AsyncValue.data(next);
    await ref.read(presentationRepositoryProvider).saveEvaluation(next);
  }

  Future<void> updateCollectiveScore(double score) async {
    final current = state.value;
    if (current == null) return;
    final next = PresentationEvaluation(
      presentationId: current.presentationId,
      collectiveScore: score,
      memberEvaluations: current.memberEvaluations,
    );
    state = AsyncValue.data(next);
    await ref.read(presentationRepositoryProvider).saveEvaluation(next);
  }
}

final presentationHistoryProvider =
    FutureProvider<List<PresentationHistoryEntry>>((ref) {
      ref.watch(presentationListProvider);
      return ref.read(presentationRepositoryProvider).getHistory();
    });
