import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../../../consts/app_colors.dart';
import '../../../routes/routes.dart';

import '../../../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      headerBuilder: (context, constraints, shrinkOffset) {
        return Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
                (constraints.maxHeight - shrinkOffset) * 0.1,
          ),
          child: const Placeholder(
            color: kPrimary,
            fallbackHeight: 100,
          ),
        );
      },
      providerConfigs: _controller.provideConfigs,
      actions: [
        AuthStateChangeAction<SignedIn>(
          (context, state) {
            Get.offAllNamed(Routes.HOME);
          },
        ),
      ],
    );
  }
}
