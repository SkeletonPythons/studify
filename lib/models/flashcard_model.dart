import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? back;
  String? front;
  String id;
  String? content;
  String? subject;
  List<String>? tags;
  String? title;
  bool isFav;
  bool isPinned;
  bool isLearned;

  Note({
    this.front = '',
    this.back = '',
    this.subject = 'none',
    this.title = '',
    this.isFav = false,
    this.content = '',
    List<String>? tags,
    this.isPinned = false,
    this.isLearned = false,
    String? id,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        tags = tags ?? [];

  factory Note.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Note(
      id: snapshot.id,
      front: data?['front'],
      back: data?['back'],
      subject: data?['subject'],
      title: data?['title'],
      isFav: data?['isFav'],
      content: data?['content'],
      tags: data?['tags'] is Iterable ? List.from(data?['tags']) : [],
      isPinned: data?['isPinned'],
      isLearned: data?['isLearned'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (subject != null) 'subject': subject,
      if (title != null) 'title': title,
      if (isFav != null) 'isFav': isFav,
      if (content != null) 'content': content,
      if (tags != null) 'tags': tags,
      if (isPinned != null) 'isPinned': isPinned,
      if (isLearned != null) 'isLearned': isLearned,
    };
  }

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
