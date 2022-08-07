// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth.dart';
import '../../../services/db.dart';

import '../../../models/note_model.dart';

enum CardState {
  FRONT,
  BACK,
}

class OC extends GetxController with GetSingleTickerProviderStateMixin {
  Note note = Note();

  void setNote(Note note) {
    this.note = note;
  }

  late TextEditingController bc;
  late TextEditingController fc;
  late TextEditingController sc;
  late TextEditingController cc;

  /// Observable for the current card [subject] state.
  late RxString subject = note.subject!.obs;

  /// Observable for the current card [front] state.
  late RxString front = note.front!.obs;

  /// Observable for the current card [back] state.
  late RxString back = note.back!.obs;

  /// Observable for the current card [tag] state.
  late RxString tag = ''.obs;

  /// Observable for the current card [content] state.
  late RxString content = note.content!.obs;

  /// The current state of the card.
  Rx<CardState> state = CardState.FRONT.obs;

  /// The animation controller for the card.
  late AnimationController flipController;

  /// The animation for the card.
  late Animation<double> flipAnimation;

  /// Rx Value for use by animation.
  RxDouble flipValue = 0.0.obs;

  /// Observable for the [enabled] state of the [TextField]s..
  final RxBool editEnabled = RxBool(false);

  /// Turns edit mode on or off.
  void toggleEdit() {
    editEnabled.toggle();
  }

  /// Override of the [onInit] method.
  @override
  void onInit() {
    /// Initialize the the text editing controllers.

    /// Initialize the the animation controller.
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    /// Initialize the animation.
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

      /// Listen to the animation's value.
      ..addListener(() {
        flipValue.value = flipController.value;

        debugPrint(flipController.value.toString());
      })

      /// Listen to the animation's state.
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          update();
        }
      });
    super.onInit();
  }

  /// Method for gesture drag detection to manually flip the card.
  void onDrag(DragUpdateDetails deets) {
    flipController.value += deets.primaryDelta! / 300;
  }

  /// Method that is called when the user finishes dragging the card.
  /// If the user flips the card halfway, this will finish the turn to keep the
  /// card straight.
  void dragEnd() {
    if (flipController.value > .5) {
      flipController.forward(from: flipController.value);
    } else {
      flipController.reverse(from: flipController.value);
    }
  }

  /// Begins the flip animation then sets the state to the opposite of the current state.
  void flipFoward() {
    flipController.forward().then((value) => state.value = CardState.BACK);
  }

  /// Reverses the flip animation then sets the state to the opposite of the current state.
  void flipBackward() {
    flipController.reverse().then((value) => state.value = CardState.FRONT);
  }

  /// Override of the [onClose] method.
  @override
  void onClose() {
    flipController.dispose();

    super.onClose();
  }

  void addTagToLocalnote(String tag) {
    note.tags!.addIf(() => !note.tags!.contains(tag), tag);
  }

  void saveToDB() async {
    debugPrint('\nSaving to DB\n');
    await DB.instance.notes.doc(note.id).update(note.toJson()).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void deleteTag(String tag) async {
    note.tags!.remove(tag);
    await DB.instance.store
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('notes')
        .doc(note.id)
        .update({
          'tags': FieldValue.arrayRemove([tag])
        })
        .then((value) => debugPrint('deleted tag'))
        .catchError((e) {
          debugPrint('error deleting tag: $e');
        });
  }

  void toggleFav(Note note) {
    note.isFav.toggle();
  }

  void deletenote() async {
    await DB.instance.notes
        .doc(note.id)
        .delete()
        .then((value) => debugPrint('note deleted'))
        .catchError((error) => debugPrint('error deleting note: $error'));
  }
}
