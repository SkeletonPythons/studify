import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';

import '../models/flashcard_deck_model.dart';
import '../models/flashcard_model.dart';
import '../utils/sample_cards.dart';

class FlashcardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<Deck> decks = RxList<Deck>();

  late AnimationController animationController;
  late Rx<Animation<Offset>> position;

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
        return OpenContainer(
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return GridTile(
            child: Card(
              child: InkWell(
                onTap: () {
                  openContainer();
                },
                child: Center(
                  child: Text(
                    statesAndCapital[index].draw(index).q,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }, openBuilder: (BuildContext context, VoidCallback openContainer) {
          return Container();
        });
      },
      childCount: decks.length,
    ),
  );
}
