import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horse_factory/constants/database.dart';
import 'package:horse_factory/models/horse.dart';
import 'package:horse_factory/models/lesson.dart';
import 'package:horse_factory/models/party.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/utils/enum_utils.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../models/auth.dart';

class MongoDatabase {
  final BehaviorSubject<User?> _userSubject =
      BehaviorSubject<User?>.seeded(null);

  Stream<User?> get user => _userSubject.stream;
  static late Db _db;

  Future<void> connect() async {
    try {
      _db = await Db.create(mongodbUrl);
      await _db.open();
      if (kDebugMode) {
        print("Connexion à la base de données réussie !");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la connexion à la base de données : $e");
      }
    }
  }

  DbCollection getCollection(String collectionName) {
    return _db.collection(collectionName);
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void signOut() {
    _userSubject.add(null);
  }

  // --------------------Registration--------------------

  Future<void> saveUserToMongoDB(User user) async {
    final usersCollection = _db.collection('users');

    try {
      final userMap = user.toMap();
      userMap['roles'] = ['USER'];
      await usersCollection.insert(userMap);
    } catch (e) {
      print("Erreur lors de l'inscription : $e");
      throw Exception("Une erreur s'est produite lors de l'inscription.");
    }
  }

  // --------------------Login--------------------

  Future<User?> checkUserInMongoDB(String userName) async {
    final usersCollection = _db.collection('users');

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
    } finally {}
  }

  Future<void> signInWithUserNameAndPassword(
      String userName, String password, BuildContext context) async {
    final usersCollection = _db.collection('users');

    try {
      final query = where.eq('userName', userName);
      final userMap = await usersCollection.findOne(query);

      if (userMap != null) {
        final user = User.fromJson(userMap);

        if (user.password == password) {
          user.updateUser(
            id: user.id,
            roles: user.roles,
            userName: user.userName,
            email: user.email,
            password: user.password,
            age: user.age,
            phoneNumber: user.phoneNumber,
            ffe: user.ffe,
            profileImageBytes: null,
            // profilePictureUrl: user.profilePictureUrl,
          );
          _userSubject.add(user);
        } else {
          showSnackBar(context, 'Mot de passe incorrect. Veuillez réessayer.');
        }
      } else {
        showSnackBar(
            context, 'Aucun utilisateur trouvé avec ce nom d\'utilisateur.');
      }
    } catch (e) {
      print("Erreur lors de l'authentification : $e");
      showSnackBar(
          context, "Une erreur s'est produite lors de l'authentification.");
    }
  }

  Future<void> resetPassword(
      String userName, String email, String newPassword) async {
    final usersCollection = _db.collection('users');

    final query = where.eq('userName', userName).eq('email', email);
    final userMap = await usersCollection.findOne(query);

    if (userMap != null) {
      final updateBuilder = ModifierBuilder();
      updateBuilder.set('password', newPassword);

      await usersCollection.update(query, updateBuilder);
    } else {
      throw Exception('Aucun utilisateur trouvé avec cet username et email.');
    }
  }

  // --------------------Profile---------------------

  Future<void> updateUserInDatabase(User updatedUser, BuildContext context) async {
    try {
      final usersCollection = _db.collection('users');
      final query = where.eq('_id', updatedUser.id);
      final updateBuilder = ModifierBuilder();
      updateBuilder.set('userName', updatedUser.userName);
      updateBuilder.set('email', updatedUser.email);
      updateBuilder.set('password', updatedUser.password);
      updateBuilder.set('age', updatedUser.age);
      updateBuilder.set('phoneNumber', updatedUser.phoneNumber);
      updateBuilder.set('ffe', updatedUser.ffe);

      await usersCollection.update(query, updateBuilder);

      final authModel = Provider.of<AuthModel>(context, listen: false);
      authModel.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profil mis à jour avec succès"),
        ),
      );
    } catch (e) {
      print("Erreur lors de la mise à jour de l'utilisateur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Une erreur s'est produite lors de la mise à jour du profil."),
        ),
      );
    }
  }

  // --------------------Party--------------------

  Future<void> createParty(Party party) async {
    await _db.collection('parties').insert(party.toJson());
  }

  Future<List> getParties() async {
    final partiesCollection = _db.collection('parties');

    final query = where.sortBy('dateTime', descending: true);
    final partiesMap = await partiesCollection.find(query).toList();

    final parties =
        partiesMap.map((partyMap) => Party.fromJson(partyMap)).toList();

    return parties;
  }

  Future<void> addParticipant(ObjectId partyId, ObjectId userId) async {
    final partiesCollection = _db.collection('parties');

    final query = where.eq('_id', partyId);
    final updateBuilder = ModifierBuilder();
    updateBuilder.push('participants', userId);

    await partiesCollection.update(query, updateBuilder);
  }

  Future<Party?> getPartyById(ObjectId partyId) async {
    final partiesCollection = _db.collection('parties');

    final query = where.eq('_id', partyId);
    final partyMap = await partiesCollection.findOne(query);

    if (partyMap != null) {
      final party = Party.fromJson(partyMap);
      return party;
    } else {
      return null;
    }
  }

  // --------------------Lessons--------------------

  Future<void> createLesson(Lesson lesson) async {
    await _db.collection('lessons').insert(lesson.toMap());
  }

  Future<List<Lesson>> getLessons(SelectorBuilder query) async {
    final lessonsCollection = _db.collection('lessons');

    final lessonsMapList = await lessonsCollection.find(query).toList();

    List<Lesson> lessonsList =
        lessonsMapList.map((lessonMap) => Lesson.fromMap(lessonMap)).toList();

    return lessonsList;
  }

  Future<void> updateLessonStatus(ObjectId lessonId, Status status) async {
    final lessonsCollection = _db.collection('lessons');

    final query = where.eq('_id', lessonId);
    final updateBuilder = ModifierBuilder();

    String statusString = getEnumValueString(status);
    updateBuilder.set('status', statusString);

    await lessonsCollection.update(query, updateBuilder);
  }

  Future<List<User>> getUsers() async {
    final usersCollection = _db.collection('users');

    final query = where.sortBy('userName', descending: false);
    final usersMapList = await usersCollection.find(query).toList();

    final usersList =
        usersMapList.map((userMap) => User.fromJson(userMap)).toList();

    return usersList;
  }

  Future<void> deleteUser(ObjectId userId) async {
    final usersCollection = _db.collection('users');

    final query = where.eq('_id', userId);
    await usersCollection.remove(query);
  }

  Future<List<Horse>> getHorses() async {
    final horsesCollection = _db.collection('horses');

    final query = where.sortBy('name', descending: false);
    final horsesMapList = await horsesCollection.find(query).toList();

    final horsesList =
        horsesMapList.map((horseMap) => Horse.fromJson(horseMap)).toList();

    return horsesList;
  }

  Future<void> deleteHorse(ObjectId horseId) async {
    final horsesCollection = _db.collection('horses');

    final query = where.eq('_id', horseId);
    await horsesCollection.remove(query);
  }

  Future<void> addComment(ObjectId partyId, String comment) async {
    final partiesCol = _db.collection('parties');

    final query = where.eq('_id', partyId);
    final updateBuilder = ModifierBuilder();
    updateBuilder.push('comments', comment);

    await partiesCol.update(query, updateBuilder);
  }

  Future<List<String>?> getComments(ObjectId partyId) async {
    final partiesCollection = _db.collection('parties');

    final query = where.eq('_id', partyId);
    final partyMap = await partiesCollection.findOne(query);

    if (partyMap != null) {
      final party = Party.fromJson(partyMap);
      return party.comments;
    } else {
      return null;
    }
  }
}
