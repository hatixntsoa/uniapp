/// Ticket: Gp6-2 — quick incident report
class IncidentReport {
  const IncidentReport({
    required this.id,
    required this.equipmentId,
    required this.description,
    required this.reportedAt,
    required this.reporterName,
  });

  final String id;
  final String equipmentId;
  final String description;
  final DateTime reportedAt;
  final String reporterName;
}
