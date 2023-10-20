import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class User with ChangeNotifier {
  late ObjectId id;
  late List<String> roles = [];
  late String userName;
  late String email;
  late String password;
  late String age;
  late String phoneNumber;
  late String ffe;
  late Uint8List? profileImageBytes;

  User({
    ObjectId? id,
    required this.userName,
    required this.email,
    required this.password,
    required this.profileImageBytes,
    required this.age,
    required this.phoneNumber,
    required this.ffe,
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
      'age': age,
      'phoneNumber': phoneNumber,
      'ffe': ffe,
      'profileImageBytes': profileImageBytes,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final profileImageBytesDynamic = json['profileImageBytes'];
    Uint8List? profileImageBytes;

    if (profileImageBytesDynamic is List<dynamic>) {
      profileImageBytes =
          Uint8List.fromList(profileImageBytesDynamic.cast<int>());
    } else if (profileImageBytesDynamic is Uint8List) {
      profileImageBytes = profileImageBytesDynamic;
    }

    return User(
      id: json['_id'] as ObjectId?,
      userName: json['userName'] as String? ?? '',
      // Handle null value with a default
      email: json['email'] as String? ?? '',
      // Handle null value with a default
      password: json['password'] as String? ?? '',
      // Handle null value with a default
      age: json['age'] as String? ?? '',
      // Handle null value with a default
      phoneNumber: json['phoneNumber'] as String? ?? '',
      // Handle null value with a default
      ffe: json['ffe'] as String? ?? '',
      // Handle null value with a default
      profileImageBytes: profileImageBytes,
    )..roles = List<String>.from(json['roles'] ?? []);
  }

  void updateUser({
    ObjectId? id,
    required String userName,
    required String email,
    required String password,
    required Uint8List? profileImageBytes,
    required String age,
    required String phoneNumber,
    required String ffe,
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
    this.age = age;
    this.phoneNumber = phoneNumber;
    this.ffe = ffe;
    this.profileImageBytes = profileImageBytes;
    this.roles = roles;
    notifyListeners();
  }
}
