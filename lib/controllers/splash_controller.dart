import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../services/auth.dart';
import '../routes/routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Splash screen animation controller.
  late AnimationController animationController;
  // Splash screen animation.
  late Animation<double> animation;

  RxDouble animationValue = 0.1.obs;

  RxBool isAnimationPlaying = false.obs;
  late RiveAnimationController rive;

  @override
  void onInit() {
    rive = OneShotAnimation('Animation 1', autoplay: false, onStop: () {
      isAnimationPlaying.toggle();
      launch();
    }, onStart: () {
      isAnimationPlaying.toggle();
    });
    super.onInit();
  }

  Future<void> launch() async {
    Future.delayed(const Duration(seconds: 2), () {
      if (!Auth.instance.isLoggedIn.value) {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  @override
  void onReady() {
    rive.isActive = true;
    super.onReady();
  }

  Duration duration = const Duration(milliseconds: 800);

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
}
