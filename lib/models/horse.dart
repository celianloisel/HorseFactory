import 'package:mongo_dart/mongo_dart.dart';

class Horse {
  final ObjectId id;
  final String name;
  final String age;

  Horse({
    required this.id,
    required this.name,
    required this.age,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'age': age,
    };
  }
}
