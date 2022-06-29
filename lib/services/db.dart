// ignore_for_file: unused_element
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import './auth.dart';
import '../models/flashcard_model.dart';

class DB extends GetxService {
  @override
  void onReady() {
    super.onReady();
    debugPrint('DB ready');
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('DB init');
    initDB();
  }

  final FirebaseFirestore store = FirebaseFirestore.instance;

  final RxBool _gotDB = false.obs;
  final RxString _userPath = ''.obs;

  /// Like the Auth controller, call this to access the DB.
  /// ex: DB.instance.addItem(collection, doc, item);
  static DB get instance => Get.find();

  void initDB() async {
    /// This function is used to initialize the database. It will create one if it doesn't exist.
    _userPath.value = 'users/${Auth.instance.USER.uid}';
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
            _createDB(Auth.instance.USER);
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
  }

  Future<bool> doesExist(String collection, String doc) async {
    return await store
        .doc(_userPath.value)
        .collection(collection)
        .doc(doc)
        .get()
        .then((value) => value.exists)
        .catchError((e) {
      debugPrint(e.toString());
    });
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

  Future<bool> createNewUser(AppUser user) async {
    try {
      await store.collection('users').doc(user.uid).set(user.toJson()).then(
        (value) async {
          await store
              .doc('users/${user.uid}')
              .collection('flashcards')
              .doc('initCollection')
              .set({'deck': []});
          await store
              .doc('users/${user.uid}')
              .collection('calendar')
              .doc('initCollection')
              .set({'events': []});
          await store
              .doc('users/${user.uid}')
              .collection('tasks')
              .doc('initCollection')
              .set({'tasks': []});
          await store
              .doc('users/${user.uid}')
              .collection('timers')
              .doc('initCollection')
              .set({'timers': []});
        },
      );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
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

  Future<void> _createDB(AppUser user) async {
    /// This function is used to find the database.
    /// It will create one if it doesn't exist.
    try {
      _userPath.value = 'users/${user.uid}';
      await store
          .collection('users')
          .doc(user.uid)
          .set(user.toJson())
          .whenComplete(
        () async {
          await store
              .doc(_userPath.value)
              .collection('flashcards')
              .doc('initCollection')
              .set({'deck': []});
          await store
              .doc(_userPath.value)
              .collection('calendar')
              .doc('initCollection')
              .set({'events': []});
          await store
              .doc(_userPath.value)
              .collection('tasks')
              .doc('initCollection')
              .set({'tasks': []});
          await store
              .doc(_userPath.value)
              .collection('timers')
              .doc('initCollection')
              .set({'timers': []});
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
