// ignore_for_file: prefer_const_constructors

import 'dart:math';

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
      init: FlashcardController(),
      builder: (controller) => Center(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 2.0),
            child: StreamBuilder<QuerySnapshot<Note>>(
              stream: DB.instance.notes.snapshots(),
              builder: (_, fbNotes) {
                if (fbNotes.hasData) {
                  controller.notes.clear();
                  for (var note in fbNotes.data!.docs) {
                    controller.notes.add(note.data());
                  }
                  controller.numberOfTiles.value = controller.notes.length;
                  return Obx(() => GridView.custom(
                      clipBehavior: Clip.antiAlias,
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
                                  index,
                                  note: controller.notes[index],
                                  onTap: openContainer,
                                  isSelected: false.obs,
                                );
                              },
                              openBuilder: (BuildContext context,
                                  VoidCallback closeContainer) {
                                return OpenCard(
                                  note: controller.notes[index],
                                  callback: closeContainer,
                                );
                              });
                        },
                        childCount: controller.numberOfTiles.value - 1,
                      ),
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 6,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: [
                          QuiltedGridTile(3, 2),
                          QuiltedGridTile(2, 4),
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(3, 4),
                          QuiltedGridTile(2, 2),
                        ],
                      )));
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
