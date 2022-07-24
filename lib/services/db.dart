// ignore_for_file: unused_element
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/models/pomodoro_models/history_model.dart';

import '../models/user_model.dart';
import '../utils/sample_cards.dart';
import './auth.dart';
import '../models/flashcard_model.dart';

class DB extends GetxService {
  static DB get instance => Get.find();
  final FirebaseFirestore store = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    debugPrint('DB/ready');
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('DB/init');
  }

  late StreamSubscription<QuerySnapshot<Note>> noteStream =
      notes.snapshots().listen((QuerySnapshot<Note> snapshot) {})
        ..onError((e) {
          debugPrint('Error: $e');
        });

  RxBool isNewUser = RxBool(false);

  /// Saves the sample cards to the database only if the user is new.
  void populateWithSampleNotes() async {
    await store
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('notes')
        .get()
        .then((_) async {
      if (_.docs.isEmpty) {
        WriteBatch writer = store.batch();
        for (var i = 0; i < sample.length; i++) {
          Note x = sample[i];
          writer.set<Note>(notes.doc(x.id), x);
        }
        await writer.commit();
      }
    }).catchError((e) {
      debugPrint('error populating with sample notes: $e');
    });
  }

  late final CollectionReference notesRef =
      store.collection('users').doc(Auth.instance.USER.uid).collection('notes');

  /// Shortcut to the [notes] collection.
  /// Automatically converts to [Note] objects.
  final CollectionReference<Note> notes = FirebaseFirestore.instance
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('notes')
      .withConverter<Note>(
          fromFirestore: (snapshot, _) => Note.fromFirestore(snapshot),
          toFirestore: (Note note, _) => note.toFirestore());

  /// Shortcut to access the [user] in the database.
  /// Automatically converts to [AppUSer]
  DocumentReference<AppUser> user = FirebaseFirestore.instance
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .withConverter(
          fromFirestore: ((snapshot, options) =>
              AppUser.fromFirebase(snapshot, options)),
          toFirestore: (AppUser user, _) => user.toFirestore());

  /// Shortcut to access [events] collection.
  CollectionReference get events => store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('events');

  /// Shortcut to access [timerHistory] collection.
  CollectionReference<Pomodoro> get timerHistory => store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('timerHistory')
      .withConverter(
          fromFirestore: (_, __) => Pomodoro.fromFirestore(_),
          toFirestore: (Pomodoro pomodoro, _) => pomodoro.toFirestore());

  /// Shortcut to access [timerFavorites] collection.
  CollectionReference<Pomodoro> get timerFavorites => store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('timerFavorites')
      .withConverter(
          fromFirestore: (_, __) => Pomodoro.fromFirestore(_),
          toFirestore: (Pomodoro pomodoro, _) => pomodoro.toFirestore());

  void initDB() async {
    /// This function is used to initialize the database.
    /// It will create one if it doesn't exist.
    await user.get().then((value) async {
      if (value.exists) {
        Auth.instance.USER = value.data()!;
        debugPrint('DB/getUser: user exists');
        return value.data();
      } else {
        debugPrint('DB/getUser: user does not exist');
        return null;
      }
    }).catchError((e) {
      debugPrint('error getting user: $e');
    });
  }

// USER COLLECTION //
// The following methods perform actions on the user's information in the 'users' collection.
  Future<AppUser?> getUser() async {
    return await user.get().then((value) {
      if (value.exists) {
        Auth.instance.USER = value.data()!;
        debugPrint('DB/getUser: user exists');
        return value.data();
      } else {
        debugPrint('DB/getUser: user does not exist');
        return null;
      }
    }).catchError((e) {
      debugPrint('error getting user: $e');
    });
  }

  Future<void> updateUser(AppUser user) async => this
      .user
      .set(user, SetOptions(merge: true))
      .then((_) => debugPrint('DB/updateUser ran successfully'))
      .catchError((e) => debugPrint('error with DB/updateUser: $e'));

  Future<void> deleteUser(String uid) async => await user
      .delete()
      .then((value) => debugPrint('DB/deleteUser ran successfully'))
      .catchError((e) => debugPrint('error with DB/deleteUser: $e'));
}
