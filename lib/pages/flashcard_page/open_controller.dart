// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth.dart';
import '../../services/db.dart';

import '../../models/flashcard_model.dart';

enum CardState {
  FRONT,
  BACK,
  CONTENT,
}

class OC extends GetxController {
  final RxBool editEnabled = RxBool(false);
  final RxBool fav = RxBool(false);

  final RxDouble rotation = 0.0.obs;

  Rx<CardState> state = CardState.FRONT.obs;

  late final Note note;

  void setNote(Note note) {
    this.note = note;
  }

  void deleteNote(Note note) async {
    try {
      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('flashcards')
          .doc(note.id)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void flipForward() {
    rotation.value = 0.5 * pi;
    switch (state.value) {
      case CardState.FRONT:
        state.value = CardState.BACK;
        break;
      case CardState.BACK:
        state.value = CardState.CONTENT;
        break;
      case CardState.CONTENT:
        state.value = CardState.FRONT;
        break;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      rotation.value = 0.0;
    });
  }

  void flipBackwards() {
    rotation.value = -0.5 * pi;
    switch (state.value) {
      case CardState.FRONT:
        state.value = CardState.CONTENT;
        break;
      case CardState.BACK:
        state.value = CardState.FRONT;
        break;
      case CardState.CONTENT:
        state.value = CardState.BACK;
        break;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      rotation.value = 0.0;
    });
  }

  void toggleEdit() {
    editEnabled.toggle();
  }

  late TextEditingController frontController =
      TextEditingController(text: note.front);
  late TextEditingController backController =
      TextEditingController(text: note.back);
  late TextEditingController titleController =
      TextEditingController(text: note.title);
  late TextEditingController tagsController;
  late TextEditingController contentController =
      TextEditingController(text: note.content);

  @override
  void onInit() {
    super.onInit();
    frontController = TextEditingController();
    backController = TextEditingController();
    titleController = TextEditingController();
    tagsController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  void onClose() {
    frontController.dispose();
    backController.dispose();
    titleController.dispose();
    super.onClose();
  }

  void toggleFav(Note note) async {
    note.isFav = !note.isFav;
    try {
      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('flashcards')
          .doc(note.id)
          .update({
        'isFav': note.isFav,
      }).then((value) => fav.toggle);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onEditComplete(Note note) async {
    try {
      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('flashcards')
          .doc(note.id)
          .update({
        'front': note.front,
        'back': note.back,
        'title': note.title,
        'content': note.content,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
