import 'package:mongo_dart/mongo_dart.dart';

enum Place {
  indoorArena,
  outdoorArena,
}

enum Discipline {
  dressage,
  showJumping,
  endurance,
}

enum Status {
  pending,
  approved,
  rejected,
  completed,
}

class Lesson {
  final ObjectId? id;
  final Place place;
  final DateTime date;
  final int duration;
  final Discipline discipline;
  final Status status;
  final ObjectId userId;

  Lesson({
    ObjectId? id,
    required Place place,
    required DateTime date,
    required int duration,
    required Discipline discipline,
    required String status,
    required ObjectId userId,
  })  : id = id,
        place = place,
        date = date,
        duration = duration,
        discipline = discipline,
        status = 'pending' == status
            ? Status.pending
            : 'approved' == status
                ? Status.approved
                : 'rejected' == status
                    ? Status.rejected
                    : Status.completed,
        userId = userId;

  // Convertit une instance de la classe Lesson en un document MongoDB
  Map<String, dynamic> toMap() {
    return {
      'place': place.toString().split('.').last,
      'date': date,
      'duration': duration,
      'discipline': discipline.toString().split('.').last,
      'status': status.toString().split('.').last,
      'userId': userId
    };
  }

  // Convertit un document MongoDB en une instance de la classe Lesson

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      place: map['place'] == 'indoorArena'
          ? Place.indoorArena
          : Place.outdoorArena,
      date: map['date'],
      duration: map['duration'] == 30 ? 30 : 60,
      discipline: map['discipline'] == 'dressage'
          ? Discipline.dressage
          : map['discipline'] == 'showJumping'
              ? Discipline.showJumping
              : Discipline.endurance,
      status: map['status'],
      userId: map['userId'],
    );
  }
}
