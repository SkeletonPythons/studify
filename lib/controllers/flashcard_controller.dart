import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/flashcard_deck_model.dart';
import '../models/flashcard_model.dart';
import '../services/db.dart';
import '../utils/sample_cards.dart';
import '../services/auth.dart';

class FlashcardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<Note> notes = <Note>[].obs;

  late RxInt numberOfTiles = notes.length.obs;

  @override
  void onReady() {
    super.onReady();
    checkNew();
    debugPrint('FlashcardController ready');
    DB.instance.notesStream().listen((data) {
      debugPrint('Got new flashcard data.');
      data.forEach((key, value) {
        Note note = Note.fromJson(value);
        if (!notes.contains(note)) {
          notes.add(note);
        }
      });
    }).onData((data) {
      debugPrint('Got new flashcard data.');
      data.forEach((key, value) {
        Note note = Note.fromJson(value);
        if (!notes.contains(note)) {
          notes.add(note);
          update();
        }
      });
    });
  }

  void checkNew() async {
    try {
      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('flashcards')
          .get()
          .then((value) {
        if (value.docs.length <= 1) {
          for (Note note in sample) {
            DB.instance.store
                .collection('users')
                .doc(Auth.instance.USER.uid)
                .collection('flashcards')
                .doc(note.id)
                .set(note.toJson());
          }
        }
        DB.instance.store
            .collection('users')
            .doc(Auth.instance.USER.uid)
            .update({
          'settings': {'isNewUser': false}
        });
        DB.instance.store
            .collection('users')
            .doc(Auth.instance.USER.uid)
            .collection('flashcards')
            .doc('initCollection')
            .delete();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Note createNote(
      {String? title = '',
      String? content = '',
      String? front = '',
      String? back = '',
      List<String>? tags = const [''],
      bool isFav = false,
      bool isPinned = false,
      bool isLearned = false}) {
    return Note(
      front: '',
      title: '',
      content: '',
      back: '',
      tags: [],
      isFav: false,
      isPinned: false,
      isLearned: false,
    );
  }
}
