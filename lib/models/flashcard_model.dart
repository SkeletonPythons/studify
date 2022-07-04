import 'dart:math';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? back;
  String? front;
  String id;
  String? content;
  // String? subject;
  List<String>? tags;
  String? subject;
  RxBool isFav;
  RxBool isPinned;
  RxBool isLearned;

  Note({
    this.front = '',
    this.back = '',
    this.subject = 'none',
    bool isFav = false,
    this.content = '',
    List<String>? tags,
    bool isPinned = false,
    bool isLearned = false,
    String? id,
  })  : id =
            id ?? (DateTime.now().millisecondsSinceEpoch + pepper()).toString(),
        tags = tags ?? [],
        isFav = isFav.obs,
        isPinned = isPinned.obs,
        isLearned = isLearned.obs;

  Note.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) : this(
          id: snapshot.id,
          front: snapshot.data()!['front'] ?? '',
          back: snapshot.data()!['back'] ?? '',
          subject: snapshot.data()!['subject'] ?? '',
          isFav: snapshot.data()!['isFav'] ?? false,
          content: snapshot.data()!['content'] ?? '',
          tags: List<String>.from(snapshot.data()!['tags']),
          isPinned: snapshot.data()!['isPinned'] ?? false,
          isLearned: snapshot.data()!['isLearned'] ?? false,
        );

  static int pepper() => Random().nextInt(1000000);

  Map<String, dynamic> toFirestore() {
    return {
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (subject != null) 'subject': subject,
      'isFav': isFav.value,
      if (content != null) 'content': content,
      if (tags != null) 'tags': tags,
      'isPinned': isPinned.value,
      'isLearned': isLearned.value,
    };
  }

  Map<String, dynamic> toJson() => {
        'front': front,
        'back': back,
        'id': id,
        'subject': subject,
        'content': content,
        'tags': tags,
        'isFav': isFav.value,
        'isPinned': isPinned.value,
        'isLearned': isLearned.value,
      };
}
