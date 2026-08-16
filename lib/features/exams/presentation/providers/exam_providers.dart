import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/exam_repository_impl.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/entities/grade_entity.dart';
import '../../domain/repositories/exam_repository.dart';
import 'dart:async';

/// Ticket: Gp1-1..Gp1-4 — providers wiring repository to UI
final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return MockExamRepository();
});

final examListProvider =
    AsyncNotifierProvider<ExamListNotifier, List<ExamEntity>>(
  ExamListNotifier.new,
);

class ExamListNotifier extends AsyncNotifier<List<ExamEntity>> {
  @override
  FutureOr<List<ExamEntity>> build() {
    return ref.read(examRepositoryProvider).getExams();
  }

  Future<void> createExam(ExamEntity exam) async {
    await ref.read(examRepositoryProvider).createExam(exam);
    state = AsyncValue.data(await ref.read(examRepositoryProvider).getExams());
  }

  Future<void> publishExam(String examId) async {
    await ref.read(examRepositoryProvider).publishExam(examId);
    state = AsyncValue.data(await ref.read(examRepositoryProvider).getExams());
  }

  Future<void> deleteExam(String examId) async {
    await ref.read(examRepositoryProvider).deleteExam(examId);
    state = AsyncValue.data(await ref.read(examRepositoryProvider).getExams());
  }
}

/// Ticket: Gp1-2 — roster/grades for a single exam
final examRosterProvider = AsyncNotifierProvider.family<ExamRosterNotifier, List<GradeEntity>, String>(ExamRosterNotifier.new);

class ExamRosterNotifier
    extends FamilyAsyncNotifier<List<GradeEntity>, String> {
  @override
  FutureOr<List<GradeEntity>> build(String examId) {
    return ref.read(examRepositoryProvider).getRoster(examId);
  }

  Future<void> updateGrade(GradeEntity grade) async {
    await ref.read(examRepositoryProvider).updateGrade(arg, grade);
    state =
        AsyncValue.data(await ref.read(examRepositoryProvider).getRoster(arg));
  }
}