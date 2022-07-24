//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//
// App: Studify
// Team: Skeleton Pythons
// Author: Justin.Morton
// Date Created: 05/15/2022
// Last Modified By: Justin.Morton
// Last Modified Date: 05/15/2022
//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: RiveAnimation.asset(
          'assets/animations/splash-v2.riv',
          animations: const ['Animation 1'],
          controllers: [controller.rive],
          antialiasing: true,
        ),
      ),
    );
  }
}
