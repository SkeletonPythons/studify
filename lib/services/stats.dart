import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth.dart';
import 'db.dart';

class MyService extends GetxService {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  /// Save the user to the database.
  Future<void> saveThis(Stats stats) async {
    /// How to save a document to the database and create a new document if it doesn't exist.
    /// or update an existing document if [SetOptions] is set to [SetOptions.merge()].
    await store
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('stats')

        /// leave [.doc] empty to automatically create an id for document.
        .doc('mystats')
        .set(stats.toFirestore(), SetOptions(merge: true))
        .then((value) => true)
        .whenComplete(() => null);

    /// How to update a document in Firestore:
    await store
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('stats')
        .doc('mystats')
        .get()
        .then(
      // !! anonymous function
      (value) async {
        if (value.exists) {
          await store
              .collection('users')
              .doc(Auth.instance.USER.uid)
              .collection('stats')
              .doc('mystats')
              .update(stats.toFirestore());
        } else {
          debugPrint('Document does not exist');
        }
      },
      // !! anonymous function
    );
  }

  void save(Stats statToSave) async {}
}

Stats mystats = Stats();

class Stats {
  Stats(
      {this.cardsCreated,
      this.testsTaken,
      this.numCorrect,
      this.numIncorrect,
      this.numSkipped,
      this.daysStudied,
      this.hoursStudied,
      this.minutesStudied,
      this.tasksCreated,
      this.tasksCompleted,
      this.tasksSkipped,
      this.tasksIncomplete,
      this.eventsCreated,
      this.eventsCompleted,
      this.totalCards});

  final double? cardsCreated;
  final double? totalCards;
  final double? testsTaken;
  final double? numCorrect;
  final double? numIncorrect;
  final double? numSkipped;
  final double? daysStudied;
  final double? hoursStudied;
  final double? minutesStudied;
  final double? tasksCreated;
  final double? tasksSkipped;
  final double? tasksCompleted;
  final double? tasksIncomplete;
  final double? eventsCreated;
  final double? eventsCompleted;

  Map<String, dynamic> toFirestore() {
    return {
      'cardsCreated': cardsCreated,
      'testsTaken': testsTaken,
      'numCorrect': numCorrect,
      'numIncorrect': numIncorrect,
      'numSkipped': numSkipped,
      'daysStudied': daysStudied,
      'hoursStudied': hoursStudied,
      'minutesStudied': minutesStudied,
      'tasksCreated': tasksCreated,
      'tasksCompleted': tasksCompleted,
      'tasksSkipped': tasksSkipped,
      'tasksIncomplete': tasksIncomplete,
      'eventsCreated': eventsCreated,
      'eventsCompleted': eventsCompleted,
      'totalCards': totalCards
    };
  }

  Map<String, dynamic> toJson() => {
        'cardsCreated': cardsCreated,
        'testsTaken': testsTaken,
        'numCorrect': numCorrect,
        'numIncorrect': numIncorrect,
        'numSkipped': numSkipped,
        'daysStudied': daysStudied,
        'hoursStudied': hoursStudied,
        'minutesStudied': minutesStudied,
        'tasksCreated': tasksCreated,
        'tasksCompleted': tasksCompleted,
        'tasksSkipped': tasksSkipped,
        'tasksIncomplete': tasksIncomplete,
        'eventsCreated': eventsCreated,
        'eventsCompleted': eventsCompleted,
        'totalCards': totalCards
      };

  factory Stats.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Stats(
      cardsCreated: data?['cardsCreated'],
      testsTaken: data?['testsTaken'],
      numCorrect: data?['numCorrect'],
      numIncorrect: data?['numIncorrect'],
      numSkipped: data?['numSkipped'],
      daysStudied: data?['daysStudied'],
      hoursStudied: data?['hoursStudied'],
      minutesStudied: data?['minutesStudied'],
      tasksCreated: data?['tasksCreated'],
      tasksCompleted: data?['tasksCompleted'],
      tasksSkipped: data?['tasksSkipped'],
      tasksIncomplete: data?['tasksIncomplete'],
      eventsCreated: data?['eventsCreated'],
      eventsCompleted: data?['eventsCompleted'],
      totalCards: data?['totalCards'],
    );
  }
}
