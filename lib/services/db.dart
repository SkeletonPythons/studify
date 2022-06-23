// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import './auth.dart';

class DB extends GetxService {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final RxBool _gotDB = false.obs;
  final RxString _userPath = ''.obs;

  /// Like the Auth controller, call this to access the DB.
  /// ex: DB.instance.addItem(collection, doc, item);
  static DB get instance => Get.find();

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

  void initDB() async {
    /// This function is used to initialize the database. It will create one if it doesn't exist.
    _userPath.value = 'users/${Auth.instance.USER.uid}';
    await _fs.collection('users').doc(Auth.instance.USER.uid).get().then(
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

    // @override
    // void onInit() {
    //   super.onInit();
    // }

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
    /// This function is used to find the database. It will create one if it doesn't exist.
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

class Database extends GetxService {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  static FirebaseFirestore get instance => Get.find();

  Future<bool> createNewUser(AppUser user) async {
    try {
      await _store.collection('users').doc(user.uid).set(user.toJson()).then(
        (value) async {
          await _store
              .doc('users/${user.uid}')
              .collection('flashcards')
              .doc('initCollection')
              .set({'deck': []});
          await _store
              .doc('users/${user.uid}')
              .collection('calendar')
              .doc('initCollection')
              .set({'events': []});
          await _store
              .doc('users/${user.uid}')
              .collection('tasks')
              .doc('initCollection')
              .set({'tasks': []});
          await _store
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

  Future<AppUser?> getUser(String uid) async {
    try {
      return await _store
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
      await _store.collection('users').doc(user.uid).update(user.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
