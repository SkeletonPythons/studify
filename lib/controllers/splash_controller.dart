import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Splash screen animation controller.
  late AnimationController animationController;
  // Splash screen animation.
  late Animation<double> animation;

  RxDouble animationValue = 0.1.obs;

  @override
  void onInit() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    animation = Tween(begin: 3.0, end: 4.0).animate(animationController)
      ..addListener(() {
        animationValue.value = animation.value;
        debugPrint(animationValue.value.toString());
      });
    animationController.forward();
    super.onInit();
  }

  Duration duration = const Duration(milliseconds: 800);
}
