// import 'package:uuid/uuid.dart';

import '../domain/entities/room_entity.dart';
import '../domain/entities/room_reservation.dart';
import '../domain/repositories/room_repository.dart';

/// Ticket: Gp8-1, Gp8-3..Gp8-6 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /rooms, /rooms/:id/reservations
/// once backend is available. Interface unchanged.
class MockRoomRepository implements RoomRepository {
  final List<RoomEntity> _rooms = [
    const RoomEntity(
      id: 'room-1',
      name: 'Amphi A',
      capacity: 200,
      type: RoomType.amphi,
      location: 'Bâtiment Principal',
      equipmentList: ['Vidéoprojecteur', 'Micro'],
      status: RoomStatus.disponible,
    ),
    const RoomEntity(
      id: 'room-2',
      name: 'Salle B12',
      capacity: 40,
      type: RoomType.salleTD,
      location: 'Bâtiment B',
      equipmentList: ['Vidéoprojecteur'],
      status: RoomStatus.occupee,
    ),
    const RoomEntity(
      id: 'room-3',
      name: 'Salle Labo 2',
      capacity: 25,
      type: RoomType.laboratoire,
      location: 'Bâtiment C',
      equipmentList: ['PC', 'Switch réseau'],
      status: RoomStatus.maintenance,
    ),
    const RoomEntity(
      id: 'room-4',
      name: 'Salle A04',
      capacity: 35,
      type: RoomType.salleTD,
      location: 'Bâtiment A',
      equipmentList: ['Tableau interactif'],
      status: RoomStatus.disponible,
    ),
  ];

  final Map<String, List<RoomReservation>> _reservations = {
    'room-2': [
      RoomReservation(
        id: 'res-1',
        roomId: 'room-2',
        title: 'Algorithmique',
        groupName: 'Groupe A',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
      ),
    ],
  };

  @override
  Future<List<RoomEntity>> getRooms({
    String? query,
    RoomType? type,
    RoomStatus? status,
    int? minCapacity,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _rooms.where((r) {
      if (query != null && query.trim().isNotEmpty) {
        if (!r.name.toLowerCase().contains(query.toLowerCase())) return false;
      }
      if (type != null && r.type != type) return false;
      if (status != null && r.status != status) return false;
      if (minCapacity != null && r.capacity < minCapacity) return false;
      return true;
    }).toList();
  }

  @override
  Future<RoomEntity> createRoom(RoomEntity room) async {
    _rooms.add(room);
    _reservations.putIfAbsent(room.id, () => []);
    return room;
  }

  @override
  Future<void> setStatus(String roomId, RoomStatus status) async {
    final i = _rooms.indexWhere((r) => r.id == roomId);
    if (i != -1) _rooms[i] = _rooms[i].copyWith(status: status);
  }

  @override
  Future<List<RoomReservation>> getReservations(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_reservations[roomId] ?? const []);
  }

  @override
  Future<RoomReservation?> checkConflict(
    String roomId,
    DateTime start,
    DateTime end,
  ) async {
    final list = _reservations[roomId] ?? const [];
    for (final r in list) {
      if (r.overlaps(start, end)) return r;
    }
    return null;
  }

  @override
  Future<RoomReservation> reserve(RoomReservation reservation) async {
    final list = _reservations.putIfAbsent(reservation.roomId, () => []);
    list.add(reservation);
    return reservation;
  }

  @override
  Future<RoomEntity?> autoAssign({
    required int minCapacity,
    required RoomType type,
    required DateTime start,
    required DateTime end,
  }) async {
    for (final room in _rooms) {
      if (room.capacity < minCapacity) continue;
      if (room.type != type) continue;
      if (room.status != RoomStatus.disponible) continue;
      final conflict = await checkConflict(room.id, start, end);
      if (conflict == null) return room;
    }
    return null;
  }
}
