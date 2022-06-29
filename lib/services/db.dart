// ignore_for_file: unused_element
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../utils/sample_cards.dart';
import './auth.dart';
import '../models/flashcard_model.dart';

class DB extends GetxService {
  static DB get instance => Get.find();
  @override
  void onReady() {
    super.onReady();
    debugPrint('DB ready');
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('DB init');
  }

  void getNewUser(AppUser user) async {
    debugPrint('DB getSettings');
    await store.collection('users').doc(user.uid).get().then((value) async {
      if (value.data()!['settings']['newUser']) {
        var writer = store.batch();
        for (int i = 0; i < sample.length; i++) {
          debugPrint(sample[i].toJson().toString());
          writer.set(
              store
                  .collection('users')
                  .doc(Auth.instance.USER.uid)
                  .collection('notes')
                  .doc(sample[i].id),
              sample[i].toJson());
        }
        await writer.commit();
      }
    });
    await store.collection('users').doc(user.uid).update({
      'settings': {
        'newUser': false,
      },
    });
  }

  final FirebaseFirestore store = FirebaseFirestore.instance;

  late final CollectionReference notes =
      store.collection('users').doc(Auth.instance.USER.uid).collection('notes');

  late final CollectionReference events = store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('events');

  late final CollectionReference timers = store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('timers');

  final RxBool _gotDB = false.obs;

  /// Like the Auth controller, call this to access the DB.
  /// ex: DB.instance.addItem(collection, doc, item);

  void syncUser() async {
    DocumentReference userRef =
        store.collection('users').doc(Auth.instance.USER.uid);
    await userRef.get().then((doc) {});
  }

  void initDB() async {
    /// This function is used to initialize the database. It will create one if it doesn't exist.
    await store.collection('users').doc(Auth.instance.USER.uid).get().then(
      (doc) {
        if (doc.exists) {
          _gotDB.value = true;
          debugPrint('DB exists');
          Auth.instance.USER.email = doc.data()?['email'] ?? '';
          Auth.instance.USER.name = doc.data()?['name'] ?? '';
          Auth.instance.USER.photoUrl = doc.data()?['photoUrl'] ?? '';
          Auth.instance.USER.uid = doc.data()?['uid'] ?? '';
        } else {
          try {
            debugPrint('Creating user doc');
            _gotDB.value = true;
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      },
    ).catchError(
      (e) {
        debugPrint(e.toString());
      },
    );
    getNewUser(Auth.instance.USER);
  }

// ** ** ** ** USER COLLECTION ** ** ** **//

  Future<AppUser?> getUser(String uid) async {
    try {
      return await store
          .collection('users')
          .doc(uid)
          .get()
          .then((value) => AppUser.fromJson(value.data()!));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> updateUser(AppUser user) async {
    try {
      await store.collection('users').doc(user.uid).update(user.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteUser(String uid) async {
    try {
      await store.collection('users').doc(uid).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

// ** ** ** // ** ** ** //

  Stream<Map<String, dynamic>> notesStream() {
    return store
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('flashcards')
        .snapshots()
        .map((event) {
      Map<String, dynamic> notes = {};
      for (var doc in event.docs) {
        notes[doc.id] = doc.data();
      }
      return notes;
    });
  }

  Future<void> addNote(Note note) {
    return store
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('flashcards')
        .doc(note.id)
        .set(note.toJson());
  }

// ** // *** / Used in the Auth process / *** // ** //

}
