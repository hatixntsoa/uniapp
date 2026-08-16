/// Ticket: Gp7-1/7-2 — activity (type, date, lieu, responsable, places, description)
enum ActivityType { conference, atelier, sortie, sport, culturel, competition }

extension ActivityTypeX on ActivityType {
  String get label => switch (this) {
    ActivityType.conference => 'Conférence',
    ActivityType.atelier => 'Atelier',
    ActivityType.sortie => 'Sortie',
    ActivityType.sport => 'Sport',
    ActivityType.culturel => 'Culturel',
    ActivityType.competition => 'Compétition',
  };
}

class ActivityEntity {
  const ActivityEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.location,
    required this.responsibleName,
    required this.totalSeats,
    required this.registeredCount,
    required this.description,
    this.isPublished = false,
  });

  final String id;
  final String title;
  final ActivityType type;
  final DateTime date;
  final String location;
  final String responsibleName;
  final int totalSeats;
  final int registeredCount;
  final String description;
  final bool isPublished;

  int get remainingSeats => totalSeats - registeredCount;
  bool get isFull => remainingSeats <= 0;

  ActivityEntity copyWith({bool? isPublished, int? registeredCount}) =>
      ActivityEntity(
        id: id,
        title: title,
        type: type,
        date: date,
        location: location,
        responsibleName: responsibleName,
        totalSeats: totalSeats,
        registeredCount: registeredCount ?? this.registeredCount,
        description: description,
        isPublished: isPublished ?? this.isPublished,
      );
}
