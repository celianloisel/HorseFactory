import 'package:mongo_dart/mongo_dart.dart';

class Party {
  final ObjectId id;
  final String name;
  final String type;
  final DateTime dateTime;
  final List<ObjectId>? participants;
  final List<String>? comments;

  Party({
    ObjectId? id,
    required this.name,
    required this.type,
    required this.dateTime,
    this.participants,
    this.comments,
  }) : id = id ?? ObjectId();

  factory Party.fromJson(Map<String, dynamic> map) {
    return Party(
      id: map['_id'] as ObjectId?,
      name: map['name'],
      type: map['type'],
      dateTime: DateTime.parse(map['dateTime']),
      participants: map['participants'] != null
          ? List<ObjectId>.from(map['participants'])
          : [],
      comments:
          map['comments'] != null ? List<String>.from(map['comments']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'dateTime': dateTime.toUtc().toIso8601String(),
      'participants': participants,
      'comments': comments,
    };
  }
}
