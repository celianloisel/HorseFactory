/**
 * La classe Lesson représente un cours d'équitation de la collection "lessons"
 * de la base de données.
 */

enum Place {
  indoor_area,
  outdoor_area,
}

enum Discipline {
  dressage,
  show_jumping,
  endurance,
}

enum Status {
  pending,
  approved,
  rejected,
  completed,
}

class Lesson {
  final String _id;
  final Place _place;
  final DateTime _date;
  final int _duration; // durée en minutes
  final Discipline _discipline;
  final Status _status;
  final String _userId;

  Lesson({
    required String id,
    required String place,
    required DateTime date,
    required int duration,
    required String discipline,
    required String status,
    required String userId,
  })  : _id = id,
        // Convertit String en enum Place
        _place = Place.values.firstWhere((e) => e.toString() == 'Place.$place'),
        _date = date,
        _duration = duration,
        // Convertit String en enum Discipline
        _discipline = Discipline.values
            .firstWhere((e) => e.toString() == 'Discipline.$discipline'),
        // Convertit String en enum Status
        _status =
            Status.values.firstWhere((e) => e.toString() == 'Status.$status'),
        _userId = userId;

  // Convertit une instance de la classe Lesson en un document MongoDB
  Map<String, dynamic> toMap() {
    return {
      'place': _place.toString().split('.').last,
      'date': _date,
      'duration': _duration,
      'discipline': _discipline.toString().split('.').last,
      'status': _status.toString().split('.').last,
      'userId': _userId
    };
  }

  // Convertit un document MongoDB en une instance de la classe Lesson
  factory Lesson.fromMap(Map<String, dynamic> map, String id) {
    return Lesson(
      id: id,
      place: map['place'],
      date: map['date'],
      duration: map['duration'],
      discipline: map['discipline'],
      status: map['status'],
      // Convertit ObjectId en String
      userId: map['userId'].$oid.toString(),
    );
  }

  String get id => _id;

  Place get place => _place;

  DateTime get date => _date;

  int get duration => _duration;

  Discipline get discipline => _discipline;

  Status get status => _status;

  String get userId => _userId;
}
