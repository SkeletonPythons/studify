import 'package:firebase_database/firebase_database.dart';

import '../models/user_model.dart';

class DB {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static Future<bool> checkIfExists(AppUser user) async {
    return await _database.ref().child(user.db!).once().then((snapshot) {
      return snapshot.snapshot.exists;
    });
  }

  static Future<void> createUser(AppUser user) async {
    await _database.ref().child(user.db!).set(user.toJson());
  }

  static Future<void> updateUser(AppUser user) async {
    await _database.ref().child(user.db!).update(user.toJson());
  }

  static Future<void> deleteUser(AppUser user) async {
    await _database.ref().child(user.db!).remove();
  }
}
