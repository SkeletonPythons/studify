import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../utils/consts/app_colors.dart';

class DashboardController extends GetxController with StateMixin<Type> {
  @override
  void onInit() {
    super.onInit();
    debugPrint('DashboardController onInit');
  }

  RxList<Color> gradientColors = [
    kBackgroundLight2,
    kBackgroundLight,
  ].obs;
}
