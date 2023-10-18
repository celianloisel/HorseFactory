import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:horse_factory/constants/database.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static connect() async {
    try {
      var db = await Db.create(MONGODB_URL);
      await db.open();
      inspect(db);
      var status = await db.serverStatus();
      if (kDebugMode) {
        print(status);
      }
      var collection = db.collection(COLLECTION_NAME);
      if (kDebugMode) {
        print(await collection.find().toList());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la connexion à la base de données : $e");
      }
    }
  }
}
