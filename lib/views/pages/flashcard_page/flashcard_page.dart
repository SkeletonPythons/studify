import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flashcard_controller.dart';

class FlashcardPage extends StatelessWidget {
  FlashcardPage({Key? key}) : super(key: key);
  final FlashcardController controller = Get.put(FlashcardController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: controller.sliverChildDelegate.value,
              gridDelegate: controller.sliverDelegate.value,
            )
          ],
        ),
      ),
    );
  }
}
