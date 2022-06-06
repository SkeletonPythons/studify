import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../models/flashcard_deck_model.dart';
import '../models/flashcard_model.dart';

class DB extends GetxController {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  static final DB instance = Get.find();

  void initDB(AppUser user) {
    _fs.collection('users').doc(user.uid).get().then((doc) {
      if (doc.exists) {
      } else {
        _fs.collection('users').doc(user.uid).set(user.toJson());
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    DB.instance.initDB(Get.find<AppUser>());
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

  void updateFlashcardDB(AppUser user, Deck deck) {
    for (int i = 0; i < deck.flashcards.length; i++) {
      _fs
          .collection('users')
          .doc(user.uid)
          .collection('flashcards')
          .doc(deck.subject)
          .set(deck.flashcards[i].toJson());
    }
    _fs
        .collection('users')
        .doc(user.uid)
        .collection('flashcards')
        .doc(deck.subject)
        .update(deck.toJson());
  }
}
