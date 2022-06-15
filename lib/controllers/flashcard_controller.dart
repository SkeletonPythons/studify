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

  SliverGridDelegate sliverDelegate =
      // ignore: prefer_const_constructors
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 3,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
  );

  SliverChildBuilderDelegate sliverChildDelegate =
      // ignore: prefer_const_constructors
      SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      return OpenContainer(
          transitionDuration: const Duration(milliseconds: 900),
          closedColor: kBackground,
          openColor: kBackgroundLight,
          transitionType: ContainerTransitionType.fadeThrough,
          closedElevation: 4,
          openElevation: 8,
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return GridTile(
              child: InkWell(
                onTap: () {
                  openContainer();
                },
                child: Center(
                  child: Text(
                    statesAndCapital['$index']['q'],
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
          openBuilder: (BuildContext context, VoidCallback openContainer) {
            return SafeArea(
                child: Container(
              height: Get.height * .5,
              width: Get.width,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Front of Card:',
                    style: GoogleFonts.neucha(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 100, 100, 100),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    statesAndCapital['$index']['q'],
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  Text('Back of Card:',
                      style: GoogleFonts.neucha(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 100, 100, 100),
                      )),
                  Text(
                    statesAndCapital['$index']['a'],
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ));
          });
    },
    childCount: statesAndCapital.length,
  );
}
