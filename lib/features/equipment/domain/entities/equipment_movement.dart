/// Ticket: Gp5-5 — movement log (reservation, checkout, return, breakdown, maintenance)
enum MovementType { reservation, sortie, retour, panne, maintenance }

extension MovementTypeX on MovementType {
  String get label => switch (this) {
    MovementType.reservation => 'Réservation',
    MovementType.sortie => 'Sortie',
    MovementType.retour => 'Retour',
    MovementType.panne => 'Panne',
    MovementType.maintenance => 'Maintenance',
  };
}

class EquipmentMovement {
  const EquipmentMovement({
    required this.id,
    required this.equipmentId,
    required this.type,
    required this.date,
    required this.actorName,
    this.note,
  });

  final String id;
  final String equipmentId;
  final MovementType type;
  final DateTime date;
  final String actorName;
  final String? note;
}
