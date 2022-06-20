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
  Note({
    required this.front,
    required this.back,
    required this.subject,
    this.title = '',
    this.isFav = false,
    this.notes = '',
    this.tags = const [],
  }) : id = DateTime.now().millisecondsSinceEpoch;

  Note.fromJson(Map<String, dynamic> json)
      : front = json['front'],
        isFav = json['isFav'],
        back = json['back'],
        subject = json['subject'],
        notes = json['notes'],
        title = json['title'],
        tags = json['tags'],
        id = json['id'];

  String back;
  String front;
  int id;
  String? notes;
  String subject;
  List<String?> tags;
  String? title;
  bool isFav;

  Map<String, dynamic> toJson() => {
        'front': front,
        'back': back,
        'id': id,
        'subject': subject,
        'notes': notes,
        'tags': tags,
      };
}
