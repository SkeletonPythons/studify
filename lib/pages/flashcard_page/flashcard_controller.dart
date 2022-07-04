// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/flashcard_model.dart';
import '../../services/auth.dart';
import '../../services/db.dart';
import 'open_controller.dart';

class FlashcardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<Note> notes = <Note>[].obs;

  late final AnimationController iconAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> iconAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: iconAnimationController,
      curve: Curves.fastLinearToSlowEaseIn,
    ),
  );

  RxDouble menuHeight = (Get.height * .1).obs;
  RxBool menuOpen = false.obs;

  void animateMenu() {
    if (menuOpen.value) {
      iconAnimationController.reverse();
    } else {
      iconAnimationController.forward();
    }
    menuOpen.value = !menuOpen.value;
  }

  late final Stream<QuerySnapshot<Map<String, dynamic>>> noteStream = DB
      .instance.store
      .collection('users')
      .doc(Auth.instance.USER.uid)
      .collection('notes')
      .snapshots();

  RxList selectedList = [].obs;

  final Stream<QuerySnapshot<Note>> getNoteStream =
      DB.instance.notes.snapshots();

  late RxInt numberOfTiles = notes.length.obs;

  // @override
  // void onClose() {
  //   super.onClose();

  // }

  // @override
  // void onReady() async {
  //   super.onReady();

  //   }
  // }

  Note createNote(
      {String? title = 'new note',
      String? content = 'Write your ideas here.',
      String? front = 'The Front of the flashcard',
      String? back = 'The back of the flashcard',
      List<String>? tags,
      bool isFav = false,
      bool isPinned = false,
      bool isLearned = false}) {
    return Note(
      front: '',
      subject: '',
      content: '',
      back: '',
      tags: tags ?? [],
      isFav: false,
      isPinned: false,
      isLearned: false,
    );
  }
}
