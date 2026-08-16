import '../entities/room_entity.dart';
import '../entities/room_reservation.dart';

/// Ticket: Gp8-1, Gp8-3..Gp8-6 — repository contract
abstract class RoomRepository {
  Future<List<RoomEntity>> getRooms({
    String? query,
    RoomType? type,
    RoomStatus? status,
    int? minCapacity,
  });
  Future<RoomEntity> createRoom(RoomEntity room);
  Future<void> setStatus(String roomId, RoomStatus status);

  Future<List<RoomReservation>> getReservations(String roomId);

  /// Gp8-5: returns null if no conflict, or the conflicting reservation.
  Future<RoomReservation?> checkConflict(
    String roomId,
    DateTime start,
    DateTime end,
  );
  Future<RoomReservation> reserve(RoomReservation reservation);

  /// Gp8-5: auto-assignment — first available room matching capacity/type/slot.
  Future<RoomEntity?> autoAssign({
    required int minCapacity,
    required RoomType type,
    required DateTime start,
    required DateTime end,
  });
}
