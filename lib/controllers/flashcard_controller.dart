import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';

import '../models/flashcard_deck_model.dart';
import '../models/flashcard_model.dart';

class FlashcardController extends GetxController {
  RxList<Deck> decks = RxList<Deck>();

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

  Rx<SliverGridDelegate> sliverDelegate = Rx<SliverGridDelegate>(
    // ignore: prefer_const_constructors
    SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: 2,
    ),
  );

  late Rx<SliverChildDelegate> sliverChildDelegate = Rx<SliverChildDelegate>(
    // ignore: prefer_const_constructors
    SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        // return OpenContainer(
        //   duration: const Duration(seconds: 3),
        //   child: GridTile(
        //     child: Text(decks[index].subject),
        //   ),
        // );
      },
      childCount: decks.length,
    ),
  );
}
