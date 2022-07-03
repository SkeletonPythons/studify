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
}

class OC extends GetxController with GetSingleTickerProviderStateMixin {
  final RxBool editEnabled = RxBool(false);

  Rx<CardState> state = CardState.FRONT.obs;

  late AnimationController flipController;

  late Animation<double> flipAnimation;

  RxDouble flipValue = 0.0.obs;

  void toggleEdit() {
    editEnabled.toggle();
  }

  late TextEditingController frontController = TextEditingController();
  late TextEditingController backController = TextEditingController();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController tagsController = TextEditingController();
  late TextEditingController contentController = TextEditingController();

  @override
  void onInit() {
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    flipAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: pi * 2)
            .chain(CurveTween(curve: Curves.slowMiddle)),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(pi / 2),
        weight: 50,
      ),
    ]).animate(flipController)
      ..addListener(() {
        flipValue.value = flipController.value;

        debugPrint(flipController.value.toString());
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          update();
        }
      });
    super.onInit();
  }

  void onDrag(DragUpdateDetails deets) {
    flipController.value += deets.primaryDelta! / 300;
  }

  void dragEnd() {
    if (flipController.value > .5) {
      flipController.forward(from: flipController.value);
    } else {
      flipController.reverse(from: flipController.value);
    }
  }

  void flipFoward() {
    flipController.forward().then((value) => state.value = CardState.BACK);
  }

  void flipBackward() {
    flipController.reverse().then((value) => state.value = CardState.FRONT);
  }

  @override
  void onClose() {
    tagsController.dispose();
    contentController.dispose();
    flipController.dispose();
    frontController.dispose();
    backController.dispose();
    titleController.dispose();
    super.onClose();
  }

  void toggleFav(Note note) async {
    note.isFav = !note.isFav;
    try {
      await DB.instance.notes.doc(note.id).update({
        'isFav': note.isFav,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onEditComplete(Note note) async {
    try {
      await DB.instance.notes.doc(note.id).update(note.toFirestore());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteNote(Note note) async {
    try {
      await DB.instance.notes.doc(note.id).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
