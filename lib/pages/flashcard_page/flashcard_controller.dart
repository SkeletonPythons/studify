// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../models/flashcard_model.dart';
import '../../services/auth.dart';
import '../../services/db.dart';
import 'open_controller.dart';

class FlashcardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<Note> notes = <Note>[].obs;

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

class FlashcardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlashcardController>(() => FlashcardController());
    Get.create<OC>(() => OC());
  }
}
