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
  final ObjectId? _id;
  final Discipline _discipline;
  final Place _place;
  final DateTime _date;
  final int _duration; // durée en minutes
  final Status _status;
  final ObjectId _userId;

  Lesson({
    ObjectId? id,
    required String discipline,
    required String place,
    required DateTime date,
    required int duration,
    String? status,
    required ObjectId userId,
  })  :
        // par défaut, _id = null
        _id = id,
        _discipline = Discipline.values
            .firstWhere((e) => e.toString() == 'Discipline.$discipline'),
        // Convertit String en Place
        _place = Place.values.firstWhere((e) => e.toString() == 'Place.$place'),
        _date = date,
        _duration = duration,
        // Convertit String en Status, par défaut status = pending
        _status = Status.values.firstWhere(
            (e) => e.toString() == 'Status.$status',
            orElse: () => Status.pending),
        _userId = userId;

  // Convertit une instance de la classe Lesson en un document MongoDB
  Map<String, dynamic> toMap() {
    return {
      'discipline': _discipline.toString().split('.').last,
      'place': _place.toString().split('.').last,
      'date': _date,
      'duration': _duration,
      'status': _status.toString().split('.').last,
      'userId': _userId
    };
  }

  // Convertit un document MongoDB en une instance de la classe Lesson
  factory Lesson.fromMap(Map<String, dynamic> map, ObjectId? id) {
    return Lesson(
      id: map['_id'] as ObjectId?,
      discipline: map['discipline'] as String,
      place: map['place'] as String,
      date: map['date'] as DateTime,
      duration: map['duration'] as int,
      status: map['status'] as String?,
      userId: map['userId'] as ObjectId,
    );
  }

  ObjectId? get id => _id;

  Place get place => _place;

  DateTime get date => _date;

  int get duration => _duration;

  Discipline get discipline => _discipline;

  Status get status => _status;

  ObjectId get userId => _userId;
}
