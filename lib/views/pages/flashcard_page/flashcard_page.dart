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
    return Center(
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: GridView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return OpenContainer(
                  transitionDuration: const Duration(milliseconds: 900),
                  closedColor: kBackground,
                  openColor: kBackgroundLight,
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedElevation: 4,
                  openElevation: 8,
                  closedBuilder:
                      (BuildContext context, VoidCallback openContainer) {
                    return ClosedFC(index: index, onTap: openContainer);
                  },
                  openBuilder:
                      (BuildContext context, VoidCallback closeContainer) {
                    return OpenFC(index: index, onTap: closeContainer);
                  });
            },
            childCount: statesAndCapital.length,
          ),
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
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
    );
  }
}
