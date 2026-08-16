import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/subject_repository_impl.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/entities/subject_links.dart';
import '../../domain/repositories/subject_repository.dart';

/// Ticket: Gp5-1..Gp5-3 — providers
final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return MockSubjectRepository();
});

class SubjectFilter {
  const SubjectFilter({this.query = '', this.niveau, this.filiere});
  final String query;
  final String? niveau;
  final String? filiere;

  SubjectFilter copyWith({String? query, String? niveau, String? filiere}) =>
      SubjectFilter(
        query: query ?? this.query,
        niveau: niveau ?? this.niveau,
        filiere: filiere ?? this.filiere,
      );
}

final subjectFilterProvider = StateProvider<SubjectFilter>((ref) {
  return const SubjectFilter();
});

final subjectListProvider =
    AsyncNotifierProvider<SubjectListNotifier, List<SubjectEntity>>(
      SubjectListNotifier.new,
    );

class SubjectListNotifier extends AsyncNotifier<List<SubjectEntity>> {
  @override
  Future<List<SubjectEntity>> build() {
    final filter = ref.watch(subjectFilterProvider);
    return ref
        .read(subjectRepositoryProvider)
        .getSubjects(
          query: filter.query,
          niveau: filter.niveau,
          filiere: filter.filiere,
        );
  }

  Future<void> createSubject(SubjectEntity subject) async {
    await ref.read(subjectRepositoryProvider).createSubject(subject);
    ref.invalidateSelf();
  }

  Future<void> deleteSubject(String id) async {
    await ref.read(subjectRepositoryProvider).deleteSubject(id);
    ref.invalidateSelf();
  }
}

final subjectLinkSummaryProvider =
    FutureProvider.family<SubjectLinkSummary, String>((ref, subjectId) {
      return ref.read(subjectRepositoryProvider).getLinkSummary(subjectId);
    });
