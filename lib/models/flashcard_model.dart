import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  Note.fromJson(Map<String, dynamic> json, this.id)
      : front = json['front'] ?? '',
        isFav = json['isFav'] ?? false,
        back = json['back'] ?? '',
        subject = json['subject'] ?? '',
        content = json['content'] ?? '',
        title = json['title'] ?? '',
        tags = json['tags'] ?? [],
        isPinned = json['isPinned'] ?? false,
        isLearned = json['isLearned'] ?? false;

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
