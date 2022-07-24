import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/utils/consts/app_colors.dart';
import 'dart:math' as math;

import '../../models/flashcard_model.dart';
import '../../services/auth.dart';
import '../../services/db.dart';
import 'flashcard_widgets/note_card.dart';

class NotePageController extends GetxController {
  final Stream<QuerySnapshot<Note>> noteStream = DB.instance.notes.snapshots();

  RxList<Widget> slivers = <Widget>[].obs;
  RxMap<String, List<Note>> noteMap = <String, List<Note>>{}.obs;
  RxBool selectionEnabled = false.obs;

  @override
  void onReady() {
    super.onReady();
    debugPrint('NoteController/ready');
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
      debugPrint('handleData/empty');
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
    slivers.value = buildSlivers();
    update();
  }

  /// Adds a new subject to the [AppUser.subjects] list.
  void addSubject(String subject) {
    debugPrint('addSubject');
    if (subject == '') {
      throw ('Subject cannot be empty.');
    }
    if (noteMap.containsKey(subject)) {
      throw ('Subject already exists.');
    }
    noteMap[subject] = <Note>[];
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
    if (noteMap[note.subject]!.any((element) => element.id == note.id)) {
      noteMap[note.subject]!.removeWhere((element) => element.id == note.id);
      return true;
    }
    return false;
  }

  /// Method to add a [Note] object to the [notes] list.
  bool addNoteLocal(Note note) {
    if (!noteMap.containsKey(note.subject)) {
      noteMap[note.subject ?? 'no subject'] = <Note>[];
    }
    if (!noteMap[note.subject]!.any((element) => element.id == note.id)) {
      noteMap[note.subject]!.add(note);
      return true;
    } else {
      return false;
    }
  }

  /// Method to update a [Note] object in the [notes] list.
  bool updateNoteLocal(Note note) {
    if (noteMap[note.subject]!.any((element) => element.id == note.id)) {
      int index = noteMap[note.subject]!
          .indexWhere((noteElement) => note.id == noteElement.id);
      noteMap[note.subject]!.removeAt(index);
      noteMap[note.subject]!.insert(index, note);
      return true;
    } else {
      return false;
    }
  }

  ScrollController scrollController = ScrollController();

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 200.0,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x11212121),
                Color(0xdd212121),
                Color(0xff212121),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: Color(0xdd212121),
          ),
          child: Center(
            child: Text(
              headerText,
              style: GoogleFonts.ubuntu(fontSize: 20, color: kAccent),
            ),
          ),
        ),
      ),
    );
  }

  NoteCard makeNoteCard(Note note) {
    return NoteCard(this, note: note);
  }

  List<Widget> buildSlivers() {
    List<Widget> slivers = <Widget>[];
    int ind = 0;
    for (String subject in noteMap.keys) {
      slivers.add(makeHeader(subject));
      slivers.add(SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => makeNoteCard(noteMap[subject]![index]),
          childCount: noteMap[subject]!.length,
        ),
      ));
    }
    return slivers;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CollapsingList extends StatelessWidget {
  const CollapsingList({Key? key}) : super(key: key);

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 200.0,
        child: GestureDetector(
          child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [kBackground, kBackgroundLight3],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: Center(child: Text(headerText))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        makeHeader('Header Section 1'),
        SliverGrid.count(
          crossAxisCount: 3,
          children: [
            Container(color: Colors.red, height: 150.0),
            Container(color: Colors.purple, height: 150.0),
            Container(color: Colors.green, height: 150.0),
            Container(color: Colors.orange, height: 150.0),
            Container(color: Colors.yellow, height: 150.0),
            Container(color: Colors.pink, height: 150.0),
            Container(color: Colors.cyan, height: 150.0),
            Container(color: Colors.indigo, height: 150.0),
            Container(color: Colors.blue, height: 150.0),
          ],
        ),
        makeHeader('Header Section 2'),
        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [
              Container(color: Colors.red),
              Container(color: Colors.purple),
              Container(color: Colors.green),
              Container(color: Colors.orange),
              Container(color: Colors.yellow),
            ],
          ),
        ),
        makeHeader('Header Section 3'),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text('grid item $index'),
              );
            },
            childCount: 20,
          ),
        ),
        makeHeader('Header Section 4'),
        // Yes, this could also be a SliverFixedExtentList. Writing
        // this way just for an example of SliverList construction.
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(color: Colors.pink, height: 150.0),
              Container(color: Colors.cyan, height: 150.0),
              Container(color: Colors.indigo, height: 150.0),
              Container(color: Colors.blue, height: 150.0),
            ],
          ),
        ),
      ],
    );
  }
}
