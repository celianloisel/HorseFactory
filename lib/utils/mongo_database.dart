import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:horse_factory/constants/database.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static connect() async {
    try {
      var db = await Db.create(mongodbUrl);
      await db.open();
      inspect(db);
      var status = await db.serverStatus();
      if (kDebugMode) {
        print(status);
      }
      var collection = db.collection(collectionName);
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
