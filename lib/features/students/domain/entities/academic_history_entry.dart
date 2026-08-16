/// Ticket: Gp2-2 — full profile: academic history timeline entry
class AcademicHistoryEntry {
  const AcademicHistoryEntry({
    required this.title,
    required this.subtitle,
    required this.date,
    this.details = const [],
  });

  final String title;
  final String subtitle;
  final DateTime date;
  final List<String> details;
}
