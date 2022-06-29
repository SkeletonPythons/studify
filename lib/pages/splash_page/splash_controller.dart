import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../../routes/routes.dart';
import '../../services/auth.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Splash screen animation controller.

  RxBool isAnimationPlaying = false.obs;
  late RiveAnimationController rive;

  @override
  void onInit() {
    rive = OneShotAnimation('Animation 1', autoplay: false, onStop: () {
      isAnimationPlaying.value = false;
      Get.put<Auth>(Auth(), permanent: true);
      Get.offAllNamed(Routes.LOGIN);
    }, onStart: () {
      isAnimationPlaying.value = true;
    })
      ..isActive = true;

    super.onInit();
  }

  @override
  void dispose() {
    rive.dispose();
    super.dispose();
  }
}
