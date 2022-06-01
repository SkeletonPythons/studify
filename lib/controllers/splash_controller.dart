import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth.dart';

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
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween(begin: 0.01, end: 1.0).animate(animationController)
      ..addListener(() {
        animationValue.value = animation.value;
        debugPrint(animationValue.value.toString());
      });
    animationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed(Auth.instance.initialRoute.value);
      });
    });
    super.onInit();
  }

  Duration duration = const Duration(milliseconds: 800);
}
