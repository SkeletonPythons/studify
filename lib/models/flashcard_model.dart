import 'dart:math';

import 'package:flutter/cupertino.dart';

class FlashCard {
  final String id;

  final String? question;
  final String? answer;
  final String? subject;
  FlashCard({
    String? id,
    this.question,
    this.answer,
    this.subject,
  }) : id = id ??
            (DateTime.now().millisecondsSinceEpoch + Random().nextInt(10))
                .toString();

  factory FlashCard.fromFirestore(Map<String, dynamic> data) => FlashCard(
        id: data['id'],
        question: data['question'] ?? '',
        answer: data['answer'] ?? '',
        subject: data['subject'] ?? 'none',
      );

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        subject: json["subject"],
      );

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCard && runtimeType == other.runtimeType && id == other.id;

  Map<String, dynamic> toFirestore() {
    return {
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (subject != null) 'subject': subject,
    };
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question ?? '',
        "answer": answer ?? '',
        "subject": subject ?? 'none',
      };

  @override
  String toString() {
    return '\nFlashCard-$id-{\n\tsubject:\t\t$subject\n\tquestion:\t\t$question\n\tanswer:\t\t$answer\n\t}';
  }
}
