/// Ticket: Gp8-4/8-5 — occupation history, reservation, conflict view
class RoomReservation {
  const RoomReservation({
    required this.id,
    required this.roomId,
    required this.title,
    required this.groupName,
    required this.startTime,
    required this.endTime,
  });

  final String id;
  final String roomId;
  final String title;
  final String groupName;
  final DateTime startTime;
  final DateTime endTime;

  bool overlaps(DateTime start, DateTime end) {
    return start.isBefore(endTime) && end.isAfter(startTime);
  }
}
