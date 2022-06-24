import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Flashcard {
  Flashcard({
    required this.q,
    required this.a,
    required this.isLearned,
    this.notes,
  }) : id = DateTime.now().millisecondsSinceEpoch;

  Flashcard.fromJson(Map<String, dynamic> json)
      : q = json['q'],
        a = json['a'],
        id = json['id'],
        notes = json['notes'],
        isLearned = json['isLearned'];

  String a;
  int id;
  bool isLearned;
  String? notes;
  String q;

  Map<String, dynamic> toJson() => {
        'q': q,
        'a': a,
        'id': id,
        'isLearned': isLearned,
      };
}

class Note {
  String back;
  String front;
  String id;
  String? content;
  String? subject;
  List<dynamic> tags;
  String? title;
  bool isFav;
  bool isPinned;
  bool isLearned;

  Note({
    required this.front,
    required this.back,
    this.subject,
    this.title = '',
    this.isFav = false,
    this.content = '',
    this.tags = const [],
    this.isPinned = false,
    this.isLearned = false,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  factory Note.fromRawJson(String str) =>
      Note.fromJson(json.decode(str) as Map<String, dynamic>);

  Note.fromJson(Map<String, dynamic> json)
      : front = json['front'],
        isFav = json['isFav'],
        back = json['back'],
        subject = json['subject'],
        content = json['content'],
        title = json['title'],
        tags = json['tags'],
        isPinned = json['isPinned'],
        isLearned = json['isLearned'],
        id = json['id'];

  Note.fromDoc({required DocumentSnapshot snapshot})
      : id = snapshot.id,
        front = snapshot['front'],
        isFav = snapshot['isFav'],
        back = snapshot['back'],
        subject = snapshot['subject'],
        content = snapshot['content'],
        title = snapshot['title'],
        isPinned = snapshot['isPinned'],
        isLearned = snapshot['isLearned'],
        tags = snapshot['tags'];

  Map<String, dynamic> toJson() => {
        'front': front,
        'back': back,
        'id': id,
        'subject': subject,
        'content': content,
        'tags': tags,
        'title': title,
        'isFav': isFav,
        'isPinned': isPinned,
        'isLearned': isLearned,
      };
}
