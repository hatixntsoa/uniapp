import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/room_repository_impl.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/entities/room_reservation.dart';
import '../../domain/repositories/room_repository.dart';

import 'dart:core';

/// Ticket: Gp8-1, Gp8-3..Gp8-6 — providers
final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return MockRoomRepository();
});

class RoomFilter {
  const RoomFilter({this.query = '', this.type, this.status});
  final String query;
  final RoomType? type;
  final RoomStatus? status;

  RoomFilter copyWith({
    String? query,
    RoomType? type,
    bool clearType = false,
    RoomStatus? status,
    bool clearStatus = false,
  }) => RoomFilter(
    query: query ?? this.query,
    type: clearType ? null : (type ?? this.type),
    status: clearStatus ? null : (status ?? this.status),
  );
}

final roomFilterProvider = StateProvider<RoomFilter>((ref) {
  return const RoomFilter();
});

final roomListProvider =
    AsyncNotifierProvider<RoomListNotifier, List<RoomEntity>>(
      RoomListNotifier.new,
    );

class RoomListNotifier extends AsyncNotifier<List<RoomEntity>> {
  @override
  Future<List<RoomEntity>> build() {
    final filter = ref.watch(roomFilterProvider);
    return ref
        .read(roomRepositoryProvider)
        .getRooms(
          query: filter.query,
          type: filter.type,
          status: filter.status,
        );
  }

  Future<void> createRoom(RoomEntity room) async {
    await ref.read(roomRepositoryProvider).createRoom(room);
    ref.invalidateSelf();
  }

  Future<void> setStatus(String roomId, RoomStatus status) async {
    await ref.read(roomRepositoryProvider).setStatus(roomId, status);
    ref.invalidateSelf();
  }
}

final roomReservationsProvider =
    AsyncNotifierProvider.family<
      RoomReservationsNotifier,
      List<RoomReservation>,
      String
    >(RoomReservationsNotifier.new);

class RoomReservationsNotifier
    extends FamilyAsyncNotifier<List<RoomReservation>, String> {
  @override
  Future<List<RoomReservation>> build(String roomId) {
    return ref.read(roomRepositoryProvider).getReservations(roomId);
  }

  /// Gp8-5: returns an error message if a conflict is detected, else null
  /// on success.
  Future<String?> reserveWithConflictCheck(RoomReservation reservation) async {
    final conflict = await ref
        .read(roomRepositoryProvider)
        .checkConflict(
          reservation.roomId,
          reservation.startTime,
          reservation.endTime,
        );
    if (conflict != null) {
      return 'Conflit avec "${conflict.title}" (${conflict.groupName})';
    }
    await ref.read(roomRepositoryProvider).reserve(reservation);
    ref.invalidateSelf();
    return null;
  }
}
