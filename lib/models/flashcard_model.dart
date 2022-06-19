class Flashcard {
  String q;
  String a;
  String? notes;
  int id;
  bool isLearned;

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

  Map<String, dynamic> toJson() => {
        'q': q,
        'a': a,
        'id': id,
        'isLearned': isLearned,
      };
}

class Note {
  String front;
  String back;
  String subject;
  String? notes;
  String? title;
  List<String?> tags;

  int id;

  Note({
    required this.front,
    required this.back,
    required this.subject,
    this.title = '',
    this.notes = '',
    this.tags = const [],
  }) : id = DateTime.now().millisecondsSinceEpoch;

  Note.fromJson(Map<String, dynamic> json)
      : front = json['front'],
        back = json['back'],
        subject = json['subject'],
        notes = json['notes'],
        title = json['title'],
        tags = json['tags'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'front': front,
        'back': back,
        'id': id,
        'subject': subject,
        'notes': notes,
        'tags': tags,
      };
}
