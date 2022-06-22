import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/consts/app_colors.dart';
import 'dart:math';

import '../../../utils/sample_cards.dart';

class OpenFC extends StatelessWidget {
  OpenFC({
    required this.index,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final int index;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpenCardController>(
        init: Get.put(OpenCardController(index)),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'front: ',
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
                          SizedBox(
                              height: Get.height * 0.1, width: Get.width * .07),
                          OutlinedButton(
                            onPressed: () {
                              _controller.flip();
                            },
                            child: Text('test'),
                          ),
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

class OpenCardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final int index;
  OpenCardController(
    this.index,
  );
  RxBool fieldsUnlocked = RxBool(false);
  RxBool isFav = RxBool(false);
  RxBool isFlipped = RxBool(false);
  RxDouble boxSize = 100.0.obs;
  RxDouble initialSize = 100.0.obs;
  RxDouble expandedSize = 300.0.obs;

  late AnimationController flipAnimation;
  late Animation<double> animation;

  late TextEditingController frontController =
      TextEditingController(text: statesAndCapital['$index']['q']);

  void toggleFields() {
    fieldsUnlocked.toggle();
    update();
  }

  void toggleFav() {
    isFav.toggle();
    update();
  }

  void flip() {
    if (isFlipped.value) {
      flipAnimation.forward();
    } else {
      flipAnimation.reverse();
    }
    isFlipped.toggle();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    flipAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 2 * pi)
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
}
