import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/consts/app_colors.dart';

import '../models/flashcard_deck_model.dart';
import '../models/flashcard_model.dart';
import '../utils/sample_cards.dart';

class FlashcardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<Deck> decks = RxList<Deck>([]);

  @override
  void onInit() {
    super.onInit();
    decks.add(Deck.fromJson(json: statesAndCapital, id: 'States and Capitals'));
  }

  void addDeck(Deck deck) {
    decks.add(deck);
  }

  void removeDeck(Deck deck) {
    decks.remove(deck);
  }

  void shuffle() {
    decks.shuffle();
  }

  Flashcard createCard(String question, String answer) {
    return Flashcard(
      q: question,
      a: answer,
      isLearned: false,
    );
  }
}
