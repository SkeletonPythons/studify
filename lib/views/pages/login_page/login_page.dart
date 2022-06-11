import 'package:get/get.dart';
import 'package:flutter/material.dart';

import './login_widgets.dart';
import '../../../consts/app_colors.dart';
import '../../../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController _controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => AnimatedCrossFade(
              firstChild: LoginScreen(),
              secondChild: RegisterScreenUI(),
              crossFadeState: _controller.xFadeState.value,
              duration: const Duration(milliseconds: 500),
              firstCurve: Curves.easeInCubic,
              secondCurve: Curves.easeOutCubic,
              sizeCurve: Curves.easeInOutCubicEmphasized,
            ),
          ),
        ),
      ),
    );
  }
}
