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

  void _initDB(AppUser user) async {
    /// This function is used to initialize the database. It will create one if it doesn't exist.
    _userPath.value = 'users/${user.uid}';
    await _fs.collection('users').doc(user.uid).get().then(
      (doc) {
        if (doc.exists) {
          _gotDB.value = true;
        } else {
          try {
            _gotDB.value = true;
            _fs.collection('users').doc(user.uid).set(user.toJson());
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
        required String item,
        required dynamic value}) async {
      try {
        await _fs.collection(collection).doc(doc).update({
          item: value,
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    void addDeck(Deck deck) {
      _fs.doc(_userPath.value).collection('decks').add(deck.toJson());
    }

    void removeDeck(Deck deck) {
      _fs.doc(_userPath.value).collection('decks').doc(deck.id).delete();
    }

    @override
    void onReady() {
      DB.instance._initDB(Auth.instance.USER);
    }

    Future<QuerySnapshot> getCollection(String collection) async {
      return await _fs
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection(collection)
          .get();
    }

    Future<QuerySnapshot> getFlashcards(AppUser user) async {
      final QuerySnapshot querySnapshot = await _fs
          .collection('users')
          .doc(user.uid)
          .collection('flashcards')
          .get()
          .then(
        (snapshot) {
          return snapshot;
        },
      );
      return querySnapshot;
    }

    void createFlashcardDeck(AppUser user, Deck deck) async {
      try {
        for (int i = 0; i < deck.flashcards.length; i++) {
          await _fs
              .collection('users')
              .doc(user.uid)
              .collection('flashcards')
              .doc(deck.id)
              .set(deck.flashcards[i].toJson());
        }
      } catch (e) {
        debugPrint(e.toString());
        showErrorSnackBar('uh-oh', e.toString(), Get.context);
      }
    }
  }
}
