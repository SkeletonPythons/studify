import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/pages/flashcard_page/flashcard_widgets/open_card.dart';
import 'package:studify/utils/consts/app_colors.dart';

import '../../models/flashcard_model.dart';
import '../../services/auth.dart';
import '../../services/db.dart';
import 'flashcard_widgets/note_card.dart';

class NotePageController extends GetxController {
  final Stream<QuerySnapshot<Note>> noteStream = DB.instance.notes.snapshots();

  RxList<Note> notes = <Note>[].obs;
  RxList<Widget> slivers = <Widget>[].obs;

  List<String> get subjects {
    List<String> subjects = [];
    for (Note note in notes) {
      if (note.subject == null || note.subject == '') {
        continue;
      }
      if (!subjects.contains(note.subject)) {
        subjects.add(note.subject!);
      }
    }
    return subjects;
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('NoteController/ready');

    debugPrint(notes.toString());
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('NoteController/init');

    /// Listen to the notes collection.
    noteStream.listen((event) {
      if (event.docChanges.isEmpty) {
        return;
      }
      handleData(event);
    }).onError((e) {
      debugPrint('Error: $e.toString()');
    });
  }

  /// Method to get the [Note] objects from the database.
  /// Handles what to do with the document snapshot.
  /// This method only affect the [notes] list.
  void handleData(QuerySnapshot<Note> snap) {
    debugPrint('handleData');
    if (snap.docChanges.isEmpty) {
      return;
    } else if (snap.docs.isNotEmpty) {
      debugPrint('handleData/notEmpty');
    }
    for (DocumentChange<Note> change in snap.docChanges) {
      debugPrint('handleData/change');
      switch (change.type) {
        case DocumentChangeType.added:
          {
            try {
              if (!addNoteLocal(change.doc.data()!)) {
                debugPrint(
                    'Error: Firebase added a new document, but there was trouble adding it to the local list.');
              }
            } catch (e) {
              debugPrint('Error: $e.toString()');
            }
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
    slivers = buildSlivers.obs;
    update();
  }

  /// Adds a new subject to the [AppUser.subjects] list.
  void addSubject(String subject) {
    debugPrint('addSubject');
    if (subject == '') {
      throw ('Subject cannot be empty.');
    }
    if (subjects.contains(subject)) {
      throw ('Subject already exists.');
    }
    Auth.instance.USER.subjects!.add(subject);
    Auth.instance.USER.update();
  }

  /// Adds a new [Note] to the database.
  void addNote(Note note) async {
    debugPrint('NoteController/addNote');
    await DB.instance.notes.doc(note.id).set(note).catchError((e) {
      debugPrint('\n\nerror adding note: $e\n\n');
    });
  }

  /// Updates the given [Note] in the database.
  void updateNote(Note note) async {
    debugPrint('NoteController/updateNote');
    await DB.instance.notes
        .doc(note.id)
        .set(note, SetOptions(merge: true))
        .catchError((e) {
      debugPrint('\n\nerror updating note: $e\n\n');
    });
  }

  /// Deletes the given [Note] in the database.
  void deleteNote(Note note) async {
    debugPrint('NoteController/deleteNote');
    await DB.instance.notes.doc(note.id).delete().catchError((e) {
      debugPrint('\n\nerror deleting note: $e\n\n');
    });
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
    } else if (notes.any((element) => element.id == note.id)) {
      throw ('NoteController/addNoteLocal: Note already exists.');
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

  ScrollController scrollController = ScrollController();

  List<Widget> get buildSlivers {
    List<Widget> slivers = [];
    for (String subject in subjects) {
      slivers.add(
        SliverAppBar(
          floating: true,
          pinned: true,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue,
                    Colors.blue[900]!,
                  ],
                ),
              ),
              child: InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                ),
              ),
            ),
            title: Text(subject),
            centerTitle: true,
            expandedTitleScale: 2,
          ),
        ),
      );
      slivers.add(SliverToBoxAdapter(
        child: SizedBox(
          height: Get.height * 0.01,
        ),
      ));
      List<Widget> childs = [];
      for (Note note in notes) {
        if (note.subject == subject) {
          childs.add(
            Material(
                borderRadius: BorderRadius.circular(Get.height * 0.02),
                type: MaterialType.card,
                child: NoteCard(this, note: note)),
          );
        }
      }
      slivers.add(
        SliverGrid(
          delegate: SliverChildListDelegate(childs),
          // ignore: prefer_const_constructors
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
        ),
      );
    }
    return slivers;
  }
}
