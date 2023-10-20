import 'package:mongo_dart/mongo_dart.dart';

class Horse {
  final ObjectId id;
  final String name;
  final String age;
  final String color;
  final String breed;
  final String gender;
  final String specialization;
  final String photo;

  Horse({
    required this.id,
    required this.name,
    required this.age,
    required this.color,
    required this.breed,
    required this.gender,
    required this.specialization,
    required this.photo,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
      color: json['color'],
      breed: json['breed'],
      gender: json['gender'],
      specialization: json['specialization'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'age': age,
      'color': color,
      'breed': breed,
      'gender': gender,
      'specialization': specialization,
      'photo': photo,
    };
  }
}
