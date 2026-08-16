/// Ticket: Gp6-4 — class/club/activity groups
enum GroupKind { classe, club, activite }

extension GroupKindX on GroupKind {
  String get label => switch (this) {
    GroupKind.classe => 'Classe',
    GroupKind.club => 'Club',
    GroupKind.activite => 'Activité',
  };
}

class ActivityGroupEntity {
  const ActivityGroupEntity({
    required this.id,
    required this.name,
    required this.kind,
    required this.memberCount,
    required this.description,
    this.isJoined = false,
  });

  final String id;
  final String name;
  final GroupKind kind;
  final int memberCount;
  final String description;
  final bool isJoined;

  ActivityGroupEntity copyWith({bool? isJoined, int? memberCount}) =>
      ActivityGroupEntity(
        id: id,
        name: name,
        kind: kind,
        memberCount: memberCount ?? this.memberCount,
        description: description,
        isJoined: isJoined ?? this.isJoined,
      );
}
