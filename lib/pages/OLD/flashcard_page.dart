// ignore_for_file: prefer_const_constructors
// ignore_for_file:

import 'dart:math';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbols.dart';
import '../../../models/flashcard_model.dart';
import '../../../services/auth.dart';
import '../../../services/db.dart';
import '../../utils/consts/app_colors.dart';
import '../flashcard_page/flashcard_widgets/closed_card.dart';
import '../flashcard_page/flashcard_widgets/open_card.dart';
import 'flashcard_controller.dart';

class FlashcardPage extends StatelessWidget {
  const FlashcardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlashcardController>(
      init: FlashcardController(),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
          decoration: BoxDecoration(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              StreamBuilder<QuerySnapshot<Note>>(
                  stream: DB.instance.notes.snapshots(),
                  builder: (__, snapshot) {
                    // *********Build Method Begins Here**************

                    // This will execute if the stream encounters an error.
                    if (snapshot.hasError) {
                      debugPrint('stream: has error ${snapshot.error}');
                      return SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: Center(
                          child: Column(
                            children: [
                              FaIcon(FontAwesomeIcons.heartCrack,
                                  size: 100, color: Colors.redAccent[100]),
                              Text(
                                'Error getting data!',
                                style: GoogleFonts.architectsDaughter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: kAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // This will execute if the stream has data. This is the typical case.
                    if (snapshot.hasData) {
                      debugPrint('stream: has data');
                      if (_.handleData(snapshot.data!)) {
                        // _.cards = RxList<Widget>(_.buildCards(__, _.notes));
                        // return FlashcardGrid(_, cards: _.cards);
                      }
                    }
                    // This will execute if the stream is still loading data

                    else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      debugPrint('stream: waiting');
                    }

                    return SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator.adaptive(),
                            Text(
                              'Loading...',
                              style: GoogleFonts.architectsDaughter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: kAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              FCMenu(_),
            ],
          ),
        );
      },
    );
  }
}

class FlashcardGrid extends StatelessWidget {
  const FlashcardGrid(this.controller, {required this.cards, Key? key})
      : super(key: key);

  final FlashcardController controller;
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => StaggeredGrid.count(
          crossAxisCount: 6,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          children: cards,
        ),
      ),
    );
  }
}

class FCMenu extends StatelessWidget {
  const FCMenu(
    this.controller, {
    Key? key,
  }) : super(key: key);

  final FlashcardController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Obx(() => AnimatedContainer(
            height: controller.menuHeight.value,
            duration: const Duration(milliseconds: 500),
            width: Get.width * 0.2,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: Color(0xcc212121),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    controller.animateMenu();
                  },
                  icon: Obx(
                    () => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return RotationTransition(
                            turns: controller.iconAnimation,
                            child: child,
                          );
                        },
                        child: controller.menuOpen.value
                            ? Icon(
                                Icons.arrow_downward_sharp,
                                size: 34,
                              )
                            : Icon(Icons.arrow_upward_sharp, size: 34)),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.visibility.value,
                    child: Obx(() => Column(
                          children:
                              // ? controller.menuWidgets
                              const [],
                        )),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
