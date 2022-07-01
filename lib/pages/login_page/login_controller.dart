import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../routes/routes.dart';
import '../../services/auth.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/snackbars/error_snackbar.dart';

const String clientID =
    '620545516658-21ug7j0bajvrmlm7heht0lo5egmtdn7g.apps.googleusercontent.com';

class LoginController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey();

  String? val(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fields cannot be blank!';
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('LoginController onInit');
    Get.put<Auth>(Auth(), permanent: true);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;

  RxBool obscurePass = true.obs;
  RxBool obscureConfirm = true.obs;
  RxBool signinScreen = true.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fields cannot be blank!';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Enter a valid email!';
    }
    // Return null if the input is valid.
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 4) {
      return 'Username must be at least 4 characters in length';
    }
    // Return null if the entered username is valid
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters in length';
    }
    if (value != confirmPassword.value) {
      return 'Passwords do not match';
    }
    // Return null if the entered password is valid
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value != password.value) {
      return 'Passwords do not match';
    }
    // Return null if the entered password is valid
    return null;
  }

  bool isEmptyCheck(String thingToValidate) {
    if (thingToValidate.isEmpty) {
      return true;
    }
    return false;
  }

  Rx<CrossFadeState> xFadeState = Rx<CrossFadeState>(CrossFadeState.showFirst);

  void transition() {
    if (xFadeState.value == CrossFadeState.showFirst) {
      xFadeState.value = CrossFadeState.showSecond;
    } else {
      xFadeState.value = CrossFadeState.showFirst;
    }
  }

  void register(String n, String e, String p, String c) async {
    Auth.instance.newUser.value = true;
    LoadIndicator.ON();

    await Auth.instance.signUpWithEmail(email: e, password: p, name: n);
    Future.delayed(const Duration(seconds: 2), () {
      LoadIndicator.OFF();
    });
  }

  void login(String email, String pass) async {
    LoadIndicator.ON();
    try {
      {
        await Auth.instance.auth
            .signInWithEmailAndPassword(email: email, password: pass)
            .then((value) {
          LoadIndicator.OFF();
        });
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        showErrorSnackBar('uh-oh!', e.message!, Get.context);
        debugPrint(e.message);
      } else {
        showErrorSnackBar('uh-oh!', e.toString(), Get.context);
      }
      LoadIndicator.OFF();
    }
  }

  final provideConfigs = [
    const EmailProviderConfiguration(),
    const GoogleProviderConfiguration(
      clientId:
          '620545516658-21ug7j0bajvrmlm7heht0lo5egmtdn7g.apps.googleusercontent.com',
    ),
  ];
}
