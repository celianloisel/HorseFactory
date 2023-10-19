import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class User with ChangeNotifier {
  late ObjectId id;
  late List<String> roles = [];
  late String userName;
  late String email;
  late String password;
  late String profilePictureUrl;

  User({
    ObjectId? id,
    required this.userName,
    required this.email,
    required this.password,
    required this.profilePictureUrl,
  }) : id = id ?? ObjectId() {
    if (userName.isEmpty) {
      throw Exception("Le nom d'utilisateur ne peut pas être vide.");
    }
    if (email.isEmpty || !email.contains('@')) {
      throw Exception("Veuillez saisir une adresse e-mail valide.");
    }
    if (password.isEmpty || password.length < 6) {
      throw Exception("Le mot de passe doit comporter au moins 6 caractères.");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'roles': roles,
      'userName': userName,
      'email': email,
      'password': password,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as ObjectId?,
      userName: json['userName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String,
    )..roles = List<String>.from(json['roles']);
  }

  void updateUser({
    ObjectId? id,
    required String userName,
    required String email,
    required String password,
    required String profilePictureUrl,
    required List<String> roles,
  }) {
    if (userName.isEmpty) {
      throw Exception("Le nom d'utilisateur ne peut pas être vide.");
    }
    if (email.isEmpty || !email.contains('@')) {
      throw Exception("Veuillez saisir une adresse e-mail valide.");
    }
    if (password.isEmpty || password.length < 6) {
      throw Exception("Le mot de passe doit comporter au moins 6 caractères.");
    }

    this.id = id ?? ObjectId();
    this.userName = userName;
    this.email = email;
    this.password = password;
    this.profilePictureUrl = profilePictureUrl;
    this.roles = roles;
    notifyListeners();
  }
}
