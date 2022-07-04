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

  void populateWithSampleNotes() async {
    WriteBatch writer = store.batch();
    for (int i = 0; i < sample.length; i++) {
      debugPrint(sample[i].toJson().toString());
      Note x = sample[i];

      writer.set(
          store.collection('users/${Auth.instance.USER.uid}/notes').doc(x.id),
          x.toFirestore());
    }
    await writer.commit();
  }

  void checkNewUser() async {
    if (Auth.instance.newUser.value) {
      WriteBatch writer = store.batch();
      for (int i = 0; i < sample.length; i++) {
        debugPrint(sample[i].toJson().toString());

        writer.set(notes.doc(sample[i].id), sample[i].toFirestore());
      }
      await writer.commit();
    }
  }

  final FirebaseFirestore store = FirebaseFirestore.instance;

  DocumentReference<Note> setNote(Note note) => store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('notes')
      .doc(note.id)
      .withConverter(
          fromFirestore: (snapshot, _) => Note.fromFirestore(snapshot),
          toFirestore: (Note note, _) => note.toFirestore());

  CollectionReference<Note> notes = FirebaseFirestore.instance
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('notes')
      .withConverter<Note>(
          fromFirestore: (snapshot, _) => Note.fromFirestore(snapshot),
          toFirestore: (Note note, _) => note.toFirestore());

  DocumentReference<AppUser> user = FirebaseFirestore.instance
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .withConverter(
          fromFirestore: ((snapshot, options) =>
              AppUser.fromFirebase(snapshot, options)),
          toFirestore: (AppUser user, _) => user.toFirestore());

  CollectionReference get events => store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('events');

  CollectionReference get timers => store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('timers');

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
    if (await user.get().then((value) => value.exists)) {
      debugPrint('User exists');
      final appUser = await user.get();
      Auth.instance.USER = appUser.data()!;
    } else {
      debugPrint('User does not exist');
      await user.set(Auth.instance.USER, SetOptions(merge: true));
    }
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

}
