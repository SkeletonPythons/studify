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
    bool fav = false,
    this.content = '',
    List<String>? tags,
    bool pinned = false,
    bool learned = false,
    String? id,
  })  : id =
            id ?? (DateTime.now().millisecondsSinceEpoch + pepper()).toString(),
        tags = tags ?? [],
        isFav = RxBool(fav),
        isPinned = RxBool(pinned),
        isLearned = RxBool(learned);

  Note.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : id = snapshot.id,
        front = snapshot.data()!['front'] ?? '',
        back = snapshot.data()!['back'] ?? '',
        subject = snapshot.data()!['subject'] ?? '',
        content = snapshot.data()!['content'] ?? '',
        tags = List<String>.from(snapshot.data()!['tags']),
        isFav = RxBool(snapshot.data()!['isFav'] ?? false),
        isPinned = RxBool(snapshot.data()!['isPinned'] ?? false),
        isLearned = RxBool(snapshot.data()!['isLearned'] ?? false);

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'] ??
            (DateTime.now().millisecondsSinceEpoch + pepper()).toString(),
        front = json['front'] ?? '',
        back = json['back'] ?? '',
        subject = json['subject'] ?? '',
        isFav = RxBool(json['isFav'] ?? false),
        content = json['content'] ?? '',
        tags = List<String>.from(json['tags']),
        isPinned = RxBool(json['isPinned'] ?? false),
        isLearned = RxBool(json['isLearned'] ?? false);

  static int pepper() => Random().nextInt(50);

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

  @override
  String toString() {
    return '\n>-------<>-------<\nID:\t\t$id\nSUBJECT:\t$subject\nFRONT:\t$front\nBACK:\t$back\nCONTENT:\t$content\nTAGS:\t${tags.toString()}\nFAV?:\t$isFav\nPINNED?:\t$isPinned\nLEARNED?:\t$isLearned\n>-------<>-------<\n';
  }
}
