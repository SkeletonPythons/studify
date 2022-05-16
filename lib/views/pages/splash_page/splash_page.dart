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
import 'dart:math' as math;

import '../../../../controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Obx(
          () => Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFf1f1f1),
                  Color(0xFF313131),
                  Color(0xFF414141),
                  Color(0xFF414141),
                  Color(0xFF2C2C2C),
                  Color(0xFF2C2C2C),
                ],
                transform:
                    GradientRotation(math.pi / controller.animationValue.value),
              ),
            ),
            child: const Text(
              'Studify',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
