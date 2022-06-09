import 'package:get/get.dart';
import 'dart:math';
import './flashcard_model.dart';

class Deck {
  final String subject;
  RxList<Flashcard> flashcards;
  int? currentCardIndex;
  int? numCorrect;

  Deck({
    required this.subject,
    required this.flashcards,
    this.currentCardIndex = 0,
    this.numCorrect = 0,
  });

  Deck.fromJson(Map<String, dynamic> json)
      : subject = json['subject'],
        flashcards = json['flashcards'],
        currentCardIndex = 0,
        numCorrect = 0;

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'flashcards': flashcards,
      };

  Flashcard draw(int index) {
    return flashcards[index];
  }

  Flashcard drawRandom() {
    return flashcards[Random().nextInt(flashcards.length)];
  }

  void shuffle() {
    flashcards.shuffle();
  }

  void add(Flashcard flashcard) {
    flashcards.add(flashcard);
  }

  void remove(Flashcard flashcard) {
    flashcards.remove(flashcard);
  }

  void move(Flashcard flashcard, int index) {
    flashcards.removeAt(flashcards.indexOf(flashcard));
    flashcards.insert(index, flashcard);
  }

  void changeSubject(Flashcard flashcard, String newSubject, Deck newDeck) {
    // ignore: unnecessary_this
    this.remove(flashcard);
    newDeck.add(flashcard);
  }

  void createCard(String front, String back) {
    flashcards.add(Flashcard(
      q: front,
      a: back,
      isLearned: false,
    ));
  }
}
