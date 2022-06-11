import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../views/widgets/snackbars/error_snackbar.dart';

// import '../.secrets.dart';
import '../routes/routes.dart';
import '../models/user_model.dart';
import '../../../consts/app_colors.dart';
import '../views/widgets/loading_indicator.dart';

const String clientID =
    '620545516658-21ug7j0bajvrmlm7heht0lo5egmtdn7g.apps.googleusercontent.com';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // Auth.instance.auth.authStateChanges().listen((User? user) {
    //   if (Auth.instance.auth.currentUser != null) {
    //     Get.offAllNamed(Routes.NAVBAR);
    //   }
    // }
    // );
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

  bool validateEmail(String email) {
    if (isEmptyCheck(email)) {
      showErrorSnackBar(
          'Uh-oh!', 'Please enter an email address.', Get.context);
      return true;
    } else if (!email.contains('@')) {
      showErrorSnackBar(
          'Uh-oh!', 'Please enter a valid email address.', Get.context);
      return true;
    }
    return false;
  }

  bool validatePassword(String pass, confirm) {
    if (isEmptyCheck(pass) || isEmptyCheck(confirm)) {
      showErrorSnackBar('Hey!', 'Fields cannot be blank!', Get.context);
      debugPrint('error: code 111223');
      return true;
    } else if (pass.length <= 5) {
      debugPrint('error: code 44556');

      showErrorSnackBar(
          'Hey!', 'Password must be at least 6 characters long!', Get.context);
      return true;
    } else if (pass != confirm) {
      debugPrint('error: code 11345');

      showErrorSnackBar('Hey!', 'Passwords do not match!', Get.context);
      return true;
    }
    return false;
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

  void register(String n, e, p, c) {
    Auth.instance.newUser.value = true;
    LoadIndicator.ON();
    if (isEmptyCheck(n) || validateEmail(e) || validatePassword(p, c)) {
      LoadIndicator.OFF();
      debugPrint(
          'register validation error ${name.value} ${email.value} ${password.value} ${confirmPassword.value}');
      return;
    }
    Auth.instance.signUpWithEmail(e, p);
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    name.value = '';
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();

    Future.delayed(const Duration(seconds: 2), () {
      LoadIndicator.OFF();
      Get.offAllNamed(Routes.HOME);
    });
  }

  void login(String email, String pass) async {
    try {
      {
        await Auth.instance.auth
            .signInWithEmailAndPassword(email: email, password: pass);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        showErrorSnackBar('uh-oh!', e.message!, Get.context);
        debugPrint(e.message);
      } else {
        showErrorSnackBar('uh-oh!', e.toString(), Get.context);
      }
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
