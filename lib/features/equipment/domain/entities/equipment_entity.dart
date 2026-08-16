/// Ticket: Gp5-4 — equipment (category, room, state, id, responsible)
enum EquipmentCategory {
  informatique,
  audiovisuel,
  mobilier,
  laboratoire,
  reseau,
}

extension EquipmentCategoryX on EquipmentCategory {
  String get label => switch (this) {
    EquipmentCategory.informatique => 'Informatique',
    EquipmentCategory.audiovisuel => 'Audiovisuel',
    EquipmentCategory.mobilier => 'Mobilier',
    EquipmentCategory.laboratoire => 'Laboratoire',
    EquipmentCategory.reseau => 'Réseau',
  };
}

enum EquipmentState { fonctionnel, enPanne, maintenance, horsService }

extension EquipmentStateX on EquipmentState {
  String get label => switch (this) {
    EquipmentState.fonctionnel => 'Fonctionnel',
    EquipmentState.enPanne => 'En panne',
    EquipmentState.maintenance => 'En maintenance',
    EquipmentState.horsService => 'Hors service',
  };
}

class EquipmentEntity {
  const EquipmentEntity({
    required this.id,
    required this.inventoryCode,
    required this.name,
    required this.category,
    required this.roomName,
    required this.state,
    required this.responsibleName,
    this.failureCount = 0,
  });

  final String id;
  final String inventoryCode;
  final String name;
  final EquipmentCategory category;
  final String roomName;
  final EquipmentState state;
  final String responsibleName;
  final int failureCount;

  EquipmentEntity copyWith({EquipmentState? state, int? failureCount}) =>
      EquipmentEntity(
        id: id,
        inventoryCode: inventoryCode,
        name: name,
        category: category,
        roomName: roomName,
        state: state ?? this.state,
        responsibleName: responsibleName,
        failureCount: failureCount ?? this.failureCount,
      );
}
