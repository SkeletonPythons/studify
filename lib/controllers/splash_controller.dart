import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth.dart';
import '../routes/routes.dart';

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
      });

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    animationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (!Auth.instance.isLoggedIn.value) {
          Get.offAllNamed(Routes.LOGIN);
        }
      });
    });
  }

  Duration duration = const Duration(milliseconds: 800);

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
}
