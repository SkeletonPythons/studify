// ignore_for_file: constant_identifier_names
// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../models/flashcard_model.dart';
import '../../services/auth.dart';
import '../../services/db.dart';
import './flashcard_page.dart';
import 'flashcard_widgets/note_card.dart';

/// This is the controller for [FlashcardPage]. It handles the logic for the
/// the [Streambuilder] as well as for the custom menubar displayed on the
/// page. Should only have one instance of this class in the app at any time.
class FlashcardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// bool to determine if selection mode is on (not implemented yet)
  final RxBool selectionModeEnabled = RxBool(false);

  /// List of [Note] objects received from the database.
  RxList<Note> notes = <Note>[].obs;

  /// List of [NoteCard] widgets for use in the [FlashcardPage].
  RxList<Widget> cards = <NoteCard>[].obs;

  /// List of [Note] objects that are selected.
  RxList selectedList = [].obs;

  /// This controllers [onClose] method used to clean up resources.
  @override
  void onClose() {
    super.onClose();
    iconAnimationController.dispose();
  }

  @override
  void onInit() {
    super.onInit();

    // Initialize the the animation controller.
    iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialize the animation.
    iconAnimation = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: iconAnimationController,
        curve: Curves.linear,
      ),
    );
  }

  // AnimationController for the menu's icon rotation.
  late AnimationController iconAnimationController;

  // Animation for the menu's icon rotation.
  late Animation<double> iconAnimation;

  // property for menu's icon visibility.
  RxBool visibility = false.obs;

  // property for menu's overall height(open/closed state).
  late RxDouble menuHeight = (Get.height * .1).obs;

  // property to tell if menu is open
  RxBool menuOpen = false.obs;

  // method to open/close the menu
  void animateMenu() {
    if (menuOpen.value) {
      visibility.value = false;
      iconAnimationController.reverse();
      menuHeight.value = Get.height * .1;
    } else {
      iconAnimationController
          .forward()
          .then((value) => visibility.value = true);
      menuHeight.value = Get.height * .4;
    }
    menuOpen.toggle();
  }

  /// Method to get the [Note] objects from the database.
  /// Handles what to do with the document snapshot.
  /// This method only affect the [notes] list.
  bool handleData(QuerySnapshot<Note> snap) {
    if (snap.docChanges.isNotEmpty) {
      for (DocumentChange<Note> change in snap.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (!addNoteLocal(change.doc.data()!)) {
              debugPrint(
                  'Error: Firebase added a new document, but there was trouble adding it to the local list.');
            }
            break;
          case DocumentChangeType.modified:
            if (!updateNoteLocal(change.doc.data()!)) {
              debugPrint(
                  'Error: Firebase updated a document, but there was trouble updating it in the local list.');
            }
            break;
          case DocumentChangeType.removed:
            if (!removeNoteLocal(change.doc.data()!)) {
              debugPrint(
                  'Error: Firebase removed a document, but there was trouble removing it from the local list.');
            }
            break;
        }
      }
    }
    return true;
  }

  /// Method to remove a [Note] object to the [notes] list.
  bool removeNoteLocal(Note note) {
    if (notes.any((element) => element.id == note.id)) {
      notes.removeWhere((element) => element.id == note.id);
      return true;
    }
    return false;
  }

  /// Method to add a [Note] object to the [notes] list.
  bool addNoteLocal(Note note) {
    if (!notes.any((element) => element.id == note.id)) {
      notes.add(note);
      return true;
    } else {
      return false;
    }
  }

  /// Method to update a [Note] object in the [notes] list.
  bool updateNoteLocal(Note note) {
    if (notes.any((element) => element.id == note.id)) {
      int index = notes.indexWhere((note) => note.id == note.id);
      notes.removeAt(index);
      notes.insert(index, note);
      return true;
    } else {
      return false;
    }
  }

  /// Method to rebuild the [cards] list.
  List<NoteCard> buildCards(BuildContext context, List<Note> notes) {
    // ignore: no_leading_underscores_for_local_identifiers
    List<NoteCard> _cards = [];
    for (Note note in notes) {
      // _cards.add(_cardBuilder(note));
    }
    return _cards;
  }

  /// Random number generator to help with [_cardBuilder].
  Random rng = Random(DateTime.now().microsecondsSinceEpoch);
  int crossAxisHelper = 0;
  int crossCellRemaining = 6;

  /// Method to build a [NoteCard] widget.
  Container _cardBuilder(Note note) {
    if (crossCellRemaining >= 4) {
      crossAxisHelper = rng.nextInt(4) + 1;
    } else if (crossCellRemaining >= 3) {
      crossAxisHelper = rng.nextInt(3) + 1;
    } else {
      crossAxisHelper = crossCellRemaining;
    }

    if (crossAxisHelper == 1) {
      crossAxisHelper = 2;
    }
    crossCellRemaining -= crossAxisHelper;

    // NoteCard(this, note: note, crossCell: crossAxisHelper, mainCell: 3);
    crossCellRemaining -= crossAxisHelper;
    if (crossCellRemaining <= 0) {
      crossCellRemaining = 6;
    }
    return Container();
  }

  /// List of [Widget]s for the menu of the [FlashcardPage].
  late final RxList<Widget> menuWidgets = <Widget>[
    Icon(
      Icons.checklist_rtl,
      size: 34,
    ),
    Text(
      '${selectedList.length}',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
  ].obs;

  /// Get list of [Note] objects with the same [Note.subject].
  List<Note> getNotesBySubject(List<Note> allNotes, String subject) {
    return allNotes.where((element) => element.subject == subject).toList();
  }

  /// Get list of all [Note.subject]s.
  List<String> getSubjects(List<Note> allNotes) {
    List<String> subjects = [];
    for (Note note in allNotes) {
      if (!subjects.contains(note.subject)) {
        subjects.add(note.subject!);
      }
    }
    return subjects;
  }
}
