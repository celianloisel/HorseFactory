import 'package:mongo_dart/mongo_dart.dart';

enum Discipline {
  dressage,
  showJumping,
  endurance,
}

enum Place {
  indoorArena,
  outdoorArena,
}

enum Status {
  pending,
  approved,
  rejected,
}

class Lesson {
  final ObjectId? id;
  final Place place;
  final Discipline discipline;
  final DateTime date;
  final int duration;
  final Status status;
  final ObjectId userId;

  Lesson({
    ObjectId? id,
    required Discipline discipline,
    required Place place,
    required DateTime date,
    required int duration,
    Status? status,
    required ObjectId userId,
  })  : id = id,
        discipline = discipline,
        place = place,
        date = date,
        duration = duration,
        status = status ?? Status.pending,
        userId = userId;

  // Convertit une instance de la classe Lesson en un document MongoDB
  Map<String, dynamic> toMap() {
    return {
      'discipline': discipline.name,
      'place': place.name,
      'date': date,
      'duration': duration,
      'status': status.name,
      'userId': userId
    };
  }

  // Convertit un document MongoDB en une instance de la classe Lesson
  factory Lesson.fromMap(Map<String, dynamic> map) {
    Lesson lesson = Lesson(
      id: map['_id'] as ObjectId?,
      discipline: Discipline.values
          .firstWhere((e) => e.toString() == 'Discipline.${map['discipline']}'),
      place: Place.values
          .firstWhere((e) => e.toString() == 'Place.${map['place']}'),
      date: map['date'] as DateTime,
      duration: map['duration'] as int,
      status: Status.values
          .firstWhere((e) => e.toString() == 'Status.${map['status']}'),
      userId: map['userId'] as ObjectId,
    );
    return lesson;
  }
}
