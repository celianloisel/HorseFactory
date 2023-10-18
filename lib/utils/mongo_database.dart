import 'package:flutter/foundation.dart';
import 'package:horse_factory/constants/database.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static late Db _db;

  Future<void> connect() async {
    try {
      _db = await Db.create(mongodbUrl);
      await _db.open();
      if (kDebugMode) {
        print("Connection à MongoDB réussie !");
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
}
