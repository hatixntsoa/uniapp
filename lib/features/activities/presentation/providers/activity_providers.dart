import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/activity_repository_impl.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/participation_stats.dart';
import '../../domain/entities/registration_entity.dart';
import '../../domain/repositories/activity_repository.dart';

/// Ticket: Gp7-1..Gp7-5 — providers
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return MockActivityRepository();
});

final activityListProvider =
    AsyncNotifierProvider<ActivityListNotifier, List<ActivityEntity>>(
      ActivityListNotifier.new,
    );

class ActivityListNotifier extends AsyncNotifier<List<ActivityEntity>> {
  @override
  Future<List<ActivityEntity>> build() {
    return ref.read(activityRepositoryProvider).getActivities();
  }

  Future<void> createActivity(ActivityEntity activity) async {
    await ref.read(activityRepositoryProvider).createActivity(activity);
    ref.invalidateSelf();
  }

  Future<void> publishActivity(String id) async {
    await ref.read(activityRepositoryProvider).publishActivity(id);
    ref.invalidateSelf();
  }

  Future<void> register(String activityId, String studentId) async {
    await ref.read(activityRepositoryProvider).register(activityId, studentId);
    ref.invalidateSelf();
  }

  Future<void> unregister(String activityId, String studentId) async {
    await ref
        .read(activityRepositoryProvider)
        .unregister(activityId, studentId);
    ref.invalidateSelf();
  }
}

final myRegistrationsProvider =
    FutureProvider.family<List<RegistrationEntity>, String>((ref, studentId) {
      // Depend on activityListProvider so registrations refresh after register/unregister.
      ref.watch(activityListProvider);
      return ref.read(activityRepositoryProvider).getMyRegistrations(studentId);
    });

final participationStatsProvider =
    FutureProvider<List<ActivityParticipationStat>>((ref) {
      ref.watch(activityListProvider);
      return ref.read(activityRepositoryProvider).getParticipationStats();
    });
