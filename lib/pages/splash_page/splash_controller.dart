import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../../routes/routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Splash screen animation controller.

  RxBool isAnimationPlaying = false.obs;
  late RiveAnimationController rive;

  @override
  void onInit() {
    rive = OneShotAnimation(
      'Animation 1',
      autoplay: false,
    )..isActive = true;
    Future.delayed(const Duration(seconds: 4), () {
      Get.offAndToNamed(Routes.LOGIN);
    });

    super.onInit();
  }

  @override
  void dispose() {
    rive.dispose();
    super.dispose();
  }
}
