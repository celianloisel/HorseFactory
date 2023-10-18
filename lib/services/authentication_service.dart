import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/database.dart';
import '../models/user.dart';

class AuthService {
  final BehaviorSubject<User?> _userSubject = BehaviorSubject<User?>.seeded(null);

  Stream<User?> get user => _userSubject.stream;

  Future<void> registerUser(User user) async {
    final db = Db(MONGODB_URL);
    await db.open();
    final usersCollection = db.collection(COLLECTION_NAME);

    try {
      final userMap = user.toMap();
      await usersCollection.insert(userMap);
      _userSubject.add(user);
    } catch (e) {
      print("Erreur lors de l'inscription : $e");
      _userSubject.addError("Une erreur s'est produite lors de l'inscription.");
    } finally {
      await db.close();
    }
  }

  Future<void> signInWithUserNameAndPassword(
      String userName, String password, BuildContext context) async {
    var db = await Db.create(MONGODB_URL);
    await db.open();
    final usersCollection = db.collection(COLLECTION_NAME);

    try {
      final query = where.eq('userName', userName);
      final userMap = await usersCollection.findOne(query);

      if (userMap != null) {
        final user = User.fromJson(userMap);

        if (user.password == password) {
          user.updateUser(
            id: user.id,
            userName: user.userName,
            email: user.email,
            password: user.password,
            profilePictureUrl: user.profilePictureUrl,
          );
          _userSubject.add(user);
        } else {
          showSnackBar(context, 'Mot de passe incorrect. Veuillez réessayer.');
        }
      } else {
        showSnackBar(context, 'Aucun utilisateur trouvé avec ce nom d\'utilisateur.');
      }
    } catch (e) {
      print("Erreur lors de l'authentification : $e");
          showSnackBar(context, "Une erreur s'est produite lors de l'authentification.");
    } finally {
      await db.close();
    }
  }

  Future<User?> checkUserInMongoDB(String userName) async {
    var db = await Db.create(MONGODB_URL);
    await db.open();
    final usersCollection = db.collection(COLLECTION_NAME);

    try {
      final query = where.eq('userName', userName);
      final userMap = await usersCollection.findOne(query);

      if (userMap != null) {
        final user = User.fromJson(userMap);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Erreur lors de la recherche de l'utilisateur : $e");
      return null;
      } finally {
      await db.close();
      }
      }

  void signOut() {
    _userSubject.add(null);
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
