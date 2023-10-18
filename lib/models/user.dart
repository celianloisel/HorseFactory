import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class User with ChangeNotifier {
  ObjectId? id;
  String userName;
  String email;
  String password;
  String profilePictureUrl;

  User({
    this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.profilePictureUrl,
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
  }

  Map<String, dynamic> toMap() {
    return {
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
    );
  }

  void updateUser({
    ObjectId? id,
    required String userName,
    required String email,
    required String password,
    required String profilePictureUrl,
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

    this.id = id;
    this.userName = userName;
    this.email = email;
    this.password = password;
    this.profilePictureUrl = profilePictureUrl;
    notifyListeners();
  }
}
