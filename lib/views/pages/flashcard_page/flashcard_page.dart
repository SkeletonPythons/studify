import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flashcard_controller.dart';

class FlashcardPage extends StatelessWidget {
  FlashcardPage({Key? key}) : super(key: key);
  final FlashcardController controller = Get.put(FlashcardController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: Get.height,
            width: Get.width,
            child: Stack(
              children: [
                CustomScrollView(slivers: [
                  SliverGrid(
                    delegate: controller.sliverChildDelegate.value,
                    gridDelegate: controller.sliverDelegate.value,
                  )
                ]),
              ],
            )),
      ),
    );
  }
}
