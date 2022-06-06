class Flashcard {
  String q;
  String a;
  int id;
  bool isLearned;

  Flashcard({
    required this.q,
    required this.a,
    required this.isLearned,
  }) : id = DateTime.now().millisecondsSinceEpoch;

  Flashcard.fromJson(Map<String, dynamic> json)
      : q = json['q'],
        a = json['a'],
        id = json['id'],
        isLearned = json['isLearned'];

  Map<String, dynamic> toJson() => {
        'q': q,
        'a': a,
        'id': id,
        'isLearned': isLearned,
      };
}
