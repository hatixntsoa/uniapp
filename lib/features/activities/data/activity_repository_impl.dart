import 'package:uuid/uuid.dart';

import '../domain/entities/activity_entity.dart';
import '../domain/entities/participation_stats.dart';
import '../domain/entities/registration_entity.dart';
import '../domain/repositories/activity_repository.dart';

/// Ticket: Gp7-1..Gp7-5 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /activities, /activities/:id/register
/// once backend is available. Interface unchanged.
class MockActivityRepository implements ActivityRepository {
  final List<ActivityEntity> _activities = [
    ActivityEntity(
      id: 'act-1',
      title: 'Conférence IA & Éthique',
      type: ActivityType.conference,
      date: DateTime.now().add(const Duration(days: 5)),
      location: 'Amphi A',
      responsibleName: 'Karim Haddad',
      totalSeats: 150,
      registeredCount: 98,
      description: 'Table ronde sur les enjeux éthiques de l\'intelligence artificielle avec des intervenants du secteur.',
      isPublished: true,
    ),
    ActivityEntity(
      id: 'act-2',
      title: 'Tournoi de football inter-filières',
      type: ActivityType.sport,
      date: DateTime.now().add(const Duration(days: 12)),
      location: 'Terrain universitaire',
      responsibleName: 'Yacine Ouali',
      totalSeats: 60,
      registeredCount: 60,
      description: 'Compétition annuelle entre les filières de l\'université.',
      isPublished: true,
    ),
    ActivityEntity(
      id: 'act-3',
      title: 'Atelier CV & LinkedIn',
      type: ActivityType.atelier,
      date: DateTime.now().add(const Duration(days: 2)),
      location: 'Salle B12',
      responsibleName: 'Samira Djaidja',
      totalSeats: 40,
      registeredCount: 15,
      description:
          'Atelier pratique pour optimiser son CV et son profil LinkedIn.',
      isPublished: true,
    ),
  ];

  final Map<String, List<RegistrationEntity>> _registrationsByStudent = {
    'u-stud-1': [
      RegistrationEntity(
        id: 'reg-1',
        activityId: 'act-1',
        activityTitle: 'Conférence IA & Éthique',
        studentId: 'u-stud-1',
        registeredAt: DateTime.now().subtract(const Duration(days: 1)),
        status: RegistrationStatus.registered,
      ),
    ],
  };

  @override
  Future<List<ActivityEntity>> getActivities() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_activities);
  }

  @override
  Future<ActivityEntity> createActivity(ActivityEntity activity) async {
    _activities.add(activity);
    return activity;
  }

  @override
  Future<void> publishActivity(String activityId) async {
    final i = _activities.indexWhere((a) => a.id == activityId);
    if (i != -1) _activities[i] = _activities[i].copyWith(isPublished: true);
  }

  @override
  Future<List<RegistrationEntity>> getMyRegistrations(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_registrationsByStudent[studentId] ?? const []);
  }

  @override
  Future<void> register(String activityId, String studentId) async {
    final actIndex = _activities.indexWhere((a) => a.id == activityId);
    if (actIndex == -1 || _activities[actIndex].isFull) return;

    _activities[actIndex] = _activities[actIndex].copyWith(
      registeredCount: _activities[actIndex].registeredCount + 1,
    );

    final list = _registrationsByStudent.putIfAbsent(studentId, () => []);
    list.add(
      RegistrationEntity(
        id: const Uuid().v4(),
        activityId: activityId,
        activityTitle: _activities[actIndex].title,
        studentId: studentId,
        registeredAt: DateTime.now(),
        status: RegistrationStatus.registered,
      ),
    );
    // TODO(Gp7-4): trigger a reminder notification via
    // flutter_local_notifications once the notification channel is wired.
  }

  @override
  Future<void> unregister(String activityId, String studentId) async {
    final actIndex = _activities.indexWhere((a) => a.id == activityId);
    if (actIndex != -1 && _activities[actIndex].registeredCount > 0) {
      _activities[actIndex] = _activities[actIndex].copyWith(
        registeredCount: _activities[actIndex].registeredCount - 1,
      );
    }
    final list = _registrationsByStudent[studentId];
    list?.removeWhere((r) => r.activityId == activityId);
  }

  @override
  Future<List<ActivityParticipationStat>> getParticipationStats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _activities
        .map(
          (a) => ActivityParticipationStat(
            activityTitle: a.title,
            registeredCount: a.registeredCount,
            totalSeats: a.totalSeats,
          ),
        )
        .toList();
  }
}
