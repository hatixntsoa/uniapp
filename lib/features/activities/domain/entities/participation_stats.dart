/// Ticket: Gp7-5 — admin participation stats
class ActivityParticipationStat {
  const ActivityParticipationStat({
    required this.activityTitle,
    required this.registeredCount,
    required this.totalSeats,
  });
  final String activityTitle;
  final int registeredCount;
  final int totalSeats;

  double get fillRate => totalSeats == 0 ? 0 : registeredCount / totalSeats;
}
