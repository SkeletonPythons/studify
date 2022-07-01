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

  RxBool isNewUser = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    debugPrint('DB init');
  }

  void checkNewUser() async {
    if (Auth.instance.newUser.value) {
      WriteBatch writer = store.batch();
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
  }

  final FirebaseFirestore store = FirebaseFirestore.instance;

  late final notes = store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('notes')
      .withConverter(
          fromFirestore: Note.fromFirestore,
          toFirestore: (Note note, _) => note.toFirestore());

  late final CollectionReference events = store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('events');

  late final CollectionReference timers = store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('timers');

  final RxBool _gotDB = false.obs;

  void syncUser() async {
    try {
      await store.collection('users').doc(Auth.instance.USER.uid).set(
          {'email': Auth.instance.USER.email, 'name': Auth.instance.USER.name},
          SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void initDB() async {
    /// This function is used to initialize the database. It will create one if it doesn't exist.
    checkNewUser();

    await store.collection('users').doc(Auth.instance.USER.uid).get().then(
      (doc) {
        if (doc.exists) {
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

  void updateUser(AppUser user) async {
    try {
      await store
          .collection('users')
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
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
