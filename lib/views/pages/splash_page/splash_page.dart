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

import '../../../../controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Stack(
          children: <Widget>[
            Obx(
              () => Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF2C2C2C),
                      Color(0xFF313131),
                      Color(0xFF414141),
                      Color(0xFFf1f1f1),
                      Color(0xFF717171),
                      Color(0xFF414141),
                      Color(0xFF2C2C2C),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [
                      controller.animationValue.value,
                      controller.animationValue.value + .1,
                      controller.animationValue.value + .2,
                      controller.animationValue.value + .3,
                      controller.animationValue.value + .4,
                      controller.animationValue.value + .5,
                      controller.animationValue.value + .6,
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => Positioned(
                top: Get.height / 2 - 100,
                left: 50 * controller.animationValue.value,
                child: Container(
                  height: Get.height / 4,
                  width: Get.width - 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        Color(0xFF2C2C2C),
                        Color(0xFF313131),
                        Color(0xFF414141),
                        Color(0xFFf1f1f1),
                        Color(0xFF717171),
                        Color(0xFF414141),
                        Color(0xFF2C2C2C),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [
                        controller.animationValue.value,
                        controller.animationValue.value + .1,
                        controller.animationValue.value + .2,
                        controller.animationValue.value + .3,
                        controller.animationValue.value + .4,
                        controller.animationValue.value + .5,
                        controller.animationValue.value + .6,
                      ],
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'studify',
                      style: TextStyle(
                        fontSize: 75,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
