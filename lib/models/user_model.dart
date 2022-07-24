import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/db.dart';

class AppUser {
  AppUser({
    required this.uid,
    this.name = 'User',
    required this.email,
    this.photoUrl = 'photoUrl',
    Map<String, dynamic>? stats,
    Map<String, dynamic>? settings,
    List<String>? subjects,
  })  : stats = stats ??
            {
              /// Statistics that will be synced to the database.
              'cardsCreated': 0,
              'testsTaken': 0,
              'numCorrect': 0,
              'numIncorrect': 0,
              'numSkipped': 0,
              'daysStudied': 0,
              'hoursStudied': 0,
              'minutesStudied': 0,
              'tasksCreated': 0,
              'tasksCompleted': 0,
              'tasksSkipped': 0,
              'tasksIncomplete': 0,
              'eventsCreated': 0,
              'eventsCompleted': 0,
            },
        settings = settings ??
            {
              'isVerified': false,
            },
        subjects = subjects ?? [];

  String uid;
  String? name;
  String email;
  String? photoUrl;
  Map<String, dynamic>? settings;
  Map<String, dynamic>? stats;
  List<String>? subjects;

  factory AppUser.fromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return AppUser(
      uid: data?['uid'],
      name: data?['name'],
      email: data?['email'],
      photoUrl: data?['photoUrl'],
      settings: data?['settings'],
      stats: data?['stats'],
      subjects: data?['subjects'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'settings': settings,
      'stats': stats,
      'email': email,
      'uid': uid,
      'subjects': subjects,
    };
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'settings': settings,
        'stats': stats,
        'subjects': subjects,
      };

  AppUser.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        settings = json['settings'],
        subjects = json['subjects'],
        stats = json['stats'];

  void update() async {
    await DB.instance.user.set(this, SetOptions(merge: true)).catchError((e) {
      debugPrint('error updating user: $e');
    });
  }
}
