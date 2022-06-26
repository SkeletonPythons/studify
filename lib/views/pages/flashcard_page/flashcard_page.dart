// ignore_for_file: prefer_const_constructors

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../controllers/flashcard_controller.dart';
import './closed_card.dart';
import './open_card.dart';
import '../../../utils/sample_cards.dart';
import '../../../consts/app_colors.dart';

class FlashcardPage extends StatelessWidget {
  FlashcardPage({Key? key}) : super(key: key);

  final FlashcardController controller = Get.put(FlashcardController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlashcardController>(
      init: Get.put(FlashcardController()),
      builder: (controller) => Center(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Obx(
                  () => GridView.custom(
                    childrenDelegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return OpenContainer(
                            transitionDuration:
                                const Duration(milliseconds: 900),
                            closedColor: kBackground,
                            openColor: kBackgroundLight,
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedElevation: 4,
                            openElevation: 8,
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
                      childCount: controller.numberOfTiles.value,
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
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: Get.height * 0.1,
                  child: IconButton(
                    icon: Icon(Icons.note_add_outlined),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
