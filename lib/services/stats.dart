import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth.dart';
import 'db.dart';

/// Stats helper class. I thought about it and decided to just go with a field in the user document instead
/// of a collection. This is because the collection is not used for anything else and it's not really necessary since
/// everything can be stored in one field. Below is the code we went over though. Just commented it out.
///
/// Everything in [SH] (sort for 'StatsHelper' if you were wondering why i named it that lol) will be static.
///

class Save extends GetxService {
  static Save get fbdb => Get.find<Save>();
  final to = FirebaseDatabase.instance;
  DatabaseReference get ref => to.ref('stats/${Auth.instance.USER.uid}');

  void incr(key) async {
    Map<String, Object?> updates = {};
    updates["stats/${Auth.instance.USER.uid}/key"] = ServerValue.increment(1);
    await to.ref().update(updates).catchError((e) {
      debugPrint(e);
    });
  }

  void decr(key) async {
    Map<String, Object?> updates = {};
    updates["stats/${Auth.instance.USER.uid}/key"] = ServerValue.increment(-1);
    await to.ref().update(updates).catchError((e) {
      debugPrint(e);
    });
  }

  void set(key, value) async {
    Map<String, Object?> updates = {};
    updates["stats/${Auth.instance.USER.uid}/key"] = value;
    await to.ref().update(updates).catchError((e) {
      debugPrint(e);
    });
  }

  void get(key) async {
    await to.ref('stats/${Auth.instance.USER.uid}/key').once().then((snapshot) {
      debugPrint(snapshot.snapshot.value.toString());
    });
  }

  void stats(String key, dynamic value) {
    ref.child(key).set(value);
  }
}

class Stats {
  Stats({
    this.cardsCreated,
    this.logInStreak,
    this.testsTaken,
    this.testsPassed,
    this.testsFailed,
    this.totalCards,
    this.numCorrect,
    this.numIncorrect,
    this.daysStudied,
    this.hoursStudied,
    this.minutesStudied,
    this.tasksCreated,
    this.tasksSkipped,
    this.tasksCompleted,
    this.tasksIncomplete,
    this.eventsCreated,
    this.eventsCompleted,
  });

  final double? logInStreak;
  final double? testsTaken;
  final double? testsPassed;
  final double? testsFailed;

  final double? cardsCreated;
  final double? totalCards;
  final double? numCorrect;
  final double? numIncorrect;
  final double? daysStudied;
  final double? hoursStudied;
  final double? minutesStudied;
  final double? tasksCreated;
  final double? tasksSkipped;
  final double? tasksCompleted;
  final double? tasksIncomplete;
  final double? eventsCreated;
  final double? eventsCompleted;

  Map<String, dynamic> toJson() => {
        'logInStreak': logInStreak,
        'testsTaken': testsTaken,
        'testsPassed': testsPassed,
        'testsFailed': testsFailed,
        'cardsCreated': cardsCreated,
        'totalCards': totalCards,
        'numCorrect': numCorrect,
        'numIncorrect': numIncorrect,
        'daysStudied': daysStudied,
        'hoursStudied': hoursStudied,
        'minutesStudied': minutesStudied,
        'tasksCreated': tasksCreated,
        'tasksSkipped': tasksSkipped,
        'tasksCompleted': tasksCompleted,
        'tasksIncomplete': tasksIncomplete,
        'eventsCreated': eventsCreated,
        'eventsCompleted': eventsCompleted,
      };

  factory Stats.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Stats(
        cardsCreated: data?['cardsCreated'] as double,
        testsTaken: data?['testsTaken'] as double,
        numCorrect: data?['numCorrect'] as double,
        numIncorrect: data?['numIncorrect'] as double,
        daysStudied: data?['daysStudied'] as double,
        hoursStudied: data?['hoursStudied'] as double,
        minutesStudied: data?['minutesStudied'] as double,
        tasksCreated: data?['tasksCreated'] as double,
        tasksCompleted: data?['tasksCompleted'] as double,
        tasksSkipped: data?['tasksSkipped'] as double,
        tasksIncomplete: data?['tasksIncomplete'] as double,
        eventsCreated: data?['eventsCreated'] as double,
        eventsCompleted: data?['eventsCompleted'] as double,
        totalCards: data?['totalCards'] as double,
        logInStreak: data?['logInStreak'] as double,
        testsPassed: data?['testsPassed'] as double,
        testsFailed: data?['testsFailed'] as double);
  }
}


/*
class MyService extends GetxService {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  /// Save the user to the database.
  Future<void> saveThis(Stats stats) async {
    /// How to save a document to the database and create a new document if it doesn't exist.
    /// or update an existing document if [SetOptions] is set to [SetOptions.merge()].
    await DB.instance.store
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('stats')

        /// leave [.doc] empty to automatically create an id for document.
        .doc('mystats')
        .set(stats.toJson(), SetOptions(merge: true))
        .then((value) => true)
        .whenComplete(() => null);

    /// How to update a document in Firestore:
    await DB.instance.store
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('stats')
        .doc('mystats')
        .get()
        .then(
      // !! anonymous function
      (value) async {
        if (value.exists) {
          await DB.instance.store
              .collection('users')
              .doc(Auth.instance.USER.uid)
              .collection('stats')
              .doc('mystats')
              .update(stats.toJson());
        } else {
          debugPrint('Document does not exist');
        }
      },
      // !! anonymous function
    );
  }

  void save(Stats statToSave) async {}
}
*/
