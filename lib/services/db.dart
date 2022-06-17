// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/views/widgets/snackbars/error_snackbar.dart';

import '../models/user_model.dart';
import '../models/flashcard_deck_model.dart';
import './auth.dart';

class DB extends GetxController {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  /// Like the Auth controller, call this to access the DB.
  /// ex: DB.instance.addItem(collection, doc, item);
  static final DB instance = Get.find();

  final RxString _userPath = ''.obs;

  final RxBool _gotDB = false.obs;

  /// The [DocumentReference] for the user.
  DocumentReference get userDoc => _fs.doc(_userPath.value);

  /// The [CollectionReference] for the user's flashcards.
  CollectionReference get flashcardsCol =>
      _fs.collection('${_userPath.value}/flashcards');

  /// The [CollectionReference] for the user's events.
  CollectionReference get eventsCol =>
      _fs.collection('${_userPath.value}/events');

  /// The [CollectionReference] for the user's tasks.
  CollectionReference get tasksCol =>
      _fs.collection('${_userPath.value}/tasks');

  /// The [CollectionReference] for the user's timers.
  CollectionReference get timersCol =>
      _fs.collection('${_userPath.value}/timers');

  void _initDB(AppUser user) async {
    /// This function is used to initialize the database. It will create one if it doesn't exist.
    _userPath.value = 'users/${user.uid}';
    await _fs.collection('users').doc(user.uid).get().then(
      (doc) {
        if (doc.exists) {
          _gotDB.value = true;
        } else {
          try {
            _createDB(user);
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

  void addItem(
      {required String collection,
      required String name,
      required dynamic item}) async {
    /// Adds an item to the database. This will overwrite the item if it already exists.
    try {
      await _fs.collection(collection).doc(name).set(item);
    } catch (e) {
      debugPrint(e.toString());
    }

    void removeItem(
        {required String collection,
        required String doc,
        required String item}) async {
      /// Removes an item from the database.
      try {
        await _fs.collection(collection).doc(doc).update({
          item: FieldValue.delete(),
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    void updateItem(
        {required String collection,
        required String doc,
        required Map<String, dynamic> thingToUpdate}) async {
      try {
        await _fs.collection(collection).doc(doc).update(thingToUpdate);
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    @override
    void onReady() {
      super.onReady();
      DB.instance._initDB(Auth.instance.USER);
    }

    Future<QuerySnapshot> getCollection(String collection) async {
      return await _fs
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection(collection)
          .get();
    }

    Future<DocumentSnapshot> getDoc(String collection, String doc) async {
      return await _fs
          .doc(_userPath.value)
          .collection(collection)
          .doc(doc)
          .get()
          .then((value) => value)
          .catchError((e) {
        debugPrint(e.toString());
      });
    }
  }

  Future<bool> doesExist(String collection, String doc) async {
    return await _fs
        .doc(_userPath.value)
        .collection(collection)
        .doc(doc)
        .get()
        .then((value) => value.exists)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> _createDB(AppUser user) async {
    /// This function is used to create the database. It will create one if it doesn't exist.
    try {
      _userPath.value = 'users/${user.uid}';
      await _fs
          .collection('users')
          .doc(user.uid)
          .set(user.toJson())
          .whenComplete(
        () async {
          await _fs
              .doc(_userPath.value)
              .collection('flashcards')
              .doc('initCollection')
              .set({'deck': []});
          await _fs
              .doc(_userPath.value)
              .collection('calendar')
              .doc('initCollection')
              .set({'events': []});
          await _fs
              .doc(_userPath.value)
              .collection('tasks')
              .doc('initCollection')
              .set({'tasks': []});
          await _fs
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
