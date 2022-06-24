import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/consts/app_colors.dart';
import 'dart:math';

import '../../../utils/sample_cards.dart';
import '../../../controllers/flashcard_controller.dart';

class OpenFC extends StatelessWidget {
  const OpenFC({
    required this.index,
    required this.onTap,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final int index;
  final VoidCallback onTap;
  final FlashcardController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpenCardController>(
        init: OpenCardController(index),
        // ignore: no_leading_underscores_for_local_identifiers
        builder: (_controller) {
          Matrix4 transform = Matrix4.identity();
          transform.setEntry(2, 2, 0.001);
          transform.rotateY(_controller.animation.value);
          transform.scale(1.0, 1.0, 10);
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              height: Get.height,
              width: Get.width,
              color: kBackgroundLight3,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: AnimatedBuilder(
                    animation: _controller.flipAnimation,
                    builder: (context, child) {
                      Matrix4 transform = Matrix4.identity();
                      transform.setEntry(3, 2, 0.001);
                      transform.rotateY(_controller.animation.value);
                      transform.scale(1.0, 1.0, 10);
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    child: AnimatedContainer(
                      height: _controller.boxSize.value,
                      width: _controller.boxSize.value,
                      decoration: BoxDecoration(
                        color: kBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(milliseconds: 900),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * 0.1,
                            width: Get.width - 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back,
                                        color: Colors.white54),
                                    onPressed: () => onTap(),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * .55,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () => _controller.toggleFav(),
                                    icon: _controller.isFav.value
                                        ? const Icon(Icons.favorite,
                                            color: Colors.red)
                                        : const Icon(Icons.favorite_border,
                                            color: Colors.white54),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () => _controller.toggleFields(),
                                    icon: Icon(
                                      _controller.fieldsUnlocked.value
                                          ? Icons.lock_open_outlined
                                          : Icons.lock_outlined,
                                      color: _controller.fieldsUnlocked.value
                                          ? Colors.lightBlueAccent
                                          : Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeInOutSine,
                                switchOutCurve: Curves.easeInOutCubic,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: _controller.switcherChild.value,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class FrontSide extends StatelessWidget {
  const FrontSide(this.callback, this._controller, {Key? key})
      : super(key: key);

  final VoidCallback callback;
  final OpenCardController _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'front side: ',
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                color: Colors.white54,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Divider(
          color: kAccent,
          indent: Get.width * 0.05,
          endIndent: Get.width * 0.05,
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: Get.width * 0.9,
            maxHeight: Get.height * 0.5,
          ),
          color: kBackgroundLight,
          child: Obx(
            () => TextField(
              expands: true,
              maxLines: null,
              minLines: null,
              enabled: _controller.fieldsUnlocked.value,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () => callback(),
          child: const Text('test'),
        ),
      ],
    );
  }
}

class BackSide extends StatelessWidget {
  const BackSide(this.callback, {Key? key}) : super(key: key);
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'back side: ',
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                color: Colors.white54,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Divider(
          color: kAccent,
          indent: Get.width * 0.05,
          endIndent: Get.width * 0.05,
        ),
        SizedBox(height: Get.height * 0.1, width: Get.width * .07),
        OutlinedButton(
          onPressed: () => callback(),
          child: const Text('test'),
        ),
      ],
    );
  }
}

class OpenCardController extends GetxController
    with GetTickerProviderStateMixin {
  OpenCardController(
    this.index,
  );

  final FlashcardController controller = Get.find();

  late Animation<double> animation;
  late TextEditingController backController =
      TextEditingController(text: controller.notes[index].back);

  RxDouble boxSize = 100.0.obs;
  RxDouble expandedSize = 300.0.obs;
  RxBool fieldsUnlocked = RxBool(false);
  late AnimationController flipAnimation;
  late TextEditingController frontController =
      TextEditingController(text: controller.notes[index].front);

  final int index;
  RxDouble initialSize = 100.0.obs;
  RxBool isFav = RxBool(false);
  RxBool isFlipped = RxBool(false);

  late Rx<Widget> switcherChild = Rx<Widget>(FrontSide(() => flip(), this));

  @override
  void onClose() {
    super.onClose();
    frontController.dispose();
    backController.dispose();
    flipAnimation.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    flipAnimation = AnimationController(
      vsync: this,
      reverseDuration: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 300),
    );
    animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: pi)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi * 2),
          weight: 50.0,
        ),
      ],
    ).animate(flipAnimation);
  }

  void toggleFields() {
    fieldsUnlocked.toggle();
    update();
  }

  void toggleFav() {
    isFav.toggle();
    update();
  }

  void flip() async {
    isFlipped.toggle();
    if (isFlipped.value) {
      flipAnimation.forward();
      switcherChild.value = BackSide(() => flip());
    } else {
      flipAnimation.reverse();
      switcherChild.value = FrontSide(() => flip(), this);
    }
  }
}
