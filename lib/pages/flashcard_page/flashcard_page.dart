// ignore_for_file: prefer_const_constructors

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../models/flashcard_model.dart';
import '../../../services/auth.dart';
import '../../../services/db.dart';
import '../../utils/consts/app_colors.dart';
import './closed_card.dart';
import './open_card.dart';
import 'flashcard_controller.dart';

class FlashcardPage extends StatelessWidget {
  const FlashcardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlashcardController>(
      init: Get.put(FlashcardController()),
      builder: (controller) => Center(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: DB.instance.store
                  .collection('users')
                  .doc(Auth.instance.USER.uid)
                  .collection('flashcards')
                  .snapshots(),
              builder: (_, snapshots) {
                controller.notes.clear();
                if (snapshots.data != null) {
                  for (var doc in snapshots.data!.docs) {
                    controller.notes.add(Note.fromJson(
                        doc.data() as Map<String, dynamic>, doc.id));
                  }

                  return GridView.custom(
                      childrenDelegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return OpenContainer(
                              transitionDuration:
                                  const Duration(milliseconds: 900),
                              closedColor: kBackground,
                              openColor: kBackgroundLight,
                              transitionType:
                                  ContainerTransitionType.fadeThrough,
                              closedElevation: 0,
                              openElevation: 0,
                              closedBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
                                return ClosedCard(
                                    note: controller.notes[index],
                                    index: index,
                                    onTap: openContainer,
                                    controller: controller);
                              },
                              openBuilder: (BuildContext context,
                                  VoidCallback closeContainer) {
                                return OpenCard(
                                  note: controller.notes[index],
                                  callback: closeContainer,
                                );
                              });
                        },
                        childCount: controller.notes.length,
                      ),
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 4,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: [
                          const QuiltedGridTile(2, 2),
                          const QuiltedGridTile(1, 1),
                          const QuiltedGridTile(1, 1),
                          const QuiltedGridTile(1, 2),
                        ],
                      ));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
