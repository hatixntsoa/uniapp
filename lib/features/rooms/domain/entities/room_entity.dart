/// Ticket: Gp8-1/8-3 — room (capacity, type, location, equipment)
/// Ticket: Gp8-6 — statuses (indisponible/occupée/maintenance)
enum RoomType { amphi, salleTD, salleTP, laboratoire, bureau }

extension RoomTypeX on RoomType {
  String get label => switch (this) {
    RoomType.amphi => 'Amphithéâtre',
    RoomType.salleTD => 'Salle TD',
    RoomType.salleTP => 'Salle TP',
    RoomType.laboratoire => 'Laboratoire',
    RoomType.bureau => 'Bureau',
  };
}

enum RoomStatus { disponible, occupee, indisponible, maintenance }

extension RoomStatusX on RoomStatus {
  String get label => switch (this) {
    RoomStatus.disponible => 'Disponible',
    RoomStatus.occupee => 'Occupée',
    RoomStatus.indisponible => 'Indisponible',
    RoomStatus.maintenance => 'Maintenance',
  };
}

class RoomEntity {
  const RoomEntity({
    required this.id,
    required this.name,
    required this.capacity,
    required this.type,
    required this.location,
    required this.equipmentList,
    required this.status,
  });

  final String id;
  final String name;
  final int capacity;
  final RoomType type;
  final String location;
  final List<String> equipmentList;
  final RoomStatus status;

  RoomEntity copyWith({RoomStatus? status}) => RoomEntity(
    id: id,
    name: name,
    capacity: capacity,
    type: type,
    location: location,
    equipmentList: equipmentList,
    status: status ?? this.status,
  );
}
