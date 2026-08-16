/// Ticket: Gp10-3 — plan/track/evaluate/history
enum PresentationStatus { planifiee, enCours, evaluee, annulee }

extension PresentationStatusX on PresentationStatus {
  String get label => switch (this) {
    PresentationStatus.planifiee => 'Planifiée',
    PresentationStatus.enCours => 'En cours',
    PresentationStatus.evaluee => 'Évaluée',
    PresentationStatus.annulee => 'Annulée',
  };
}

class PresentationHistoryEntry {
  const PresentationHistoryEntry({
    required this.presentationId,
    required this.title,
    required this.date,
    required this.status,
    this.finalScore,
  });

  final String presentationId;
  final String title;
  final DateTime date;
  final PresentationStatus status;
  final double? finalScore;
}
