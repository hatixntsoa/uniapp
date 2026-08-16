import '../entities/activity_entity.dart';
import '../entities/participation_stats.dart';
import '../entities/registration_entity.dart';

/// Ticket: Gp7-1..Gp7-5 — repository contract
abstract class ActivityRepository {
  Future<List<ActivityEntity>> getActivities();
  Future<ActivityEntity> createActivity(ActivityEntity activity);
  Future<void> publishActivity(String activityId);

  Future<List<RegistrationEntity>> getMyRegistrations(String studentId);
  Future<void> register(String activityId, String studentId);
  Future<void> unregister(String activityId, String studentId);

  Future<List<ActivityParticipationStat>> getParticipationStats();
}
