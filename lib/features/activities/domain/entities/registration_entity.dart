/// Ticket: Gp7-3/7-4 — registration + participation history
enum RegistrationStatus { registered, cancelled, attended }

class RegistrationEntity {
  const RegistrationEntity({
    required this.id,
    required this.activityId,
    required this.activityTitle,
    required this.studentId,
    required this.registeredAt,
    required this.status,
  });

  final String id;
  final String activityId;
  final String activityTitle;
  final String studentId;
  final DateTime registeredAt;
  final RegistrationStatus status;

  RegistrationEntity copyWith({RegistrationStatus? status}) =>
      RegistrationEntity(
        id: id,
        activityId: activityId,
        activityTitle: activityTitle,
        studentId: studentId,
        registeredAt: registeredAt,
        status: status ?? this.status,
      );
}
