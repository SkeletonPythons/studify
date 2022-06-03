import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../views/widgets/snackbars/error_snackbar.dart';
import '../.secrets.dart';

class LoginController extends GetxController {
  // RxBool hidePW = true.obs;
  // RxString email = ''.obs;
  // RxString pass = ''.obs;

  // Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  // Future<void> logIn() async {
  //   try {
  //     Auth.instance.logInWithEmail(email.value.trim(), pass.value.trim());
  //   } catch (e) {
  //     if (e is FirebaseAuthException) {
  //       showErrorSnackBar('uh-oh!', e.message!, Get.context);
  //       debugPrint(e.message);
  //     } else {
  //       showErrorSnackBar('uh-oh!', e.toString(), Get.context);
  //     }
  //     formKey.value.currentState!.reset();
  //   }
  // }

  // Future<void> logInWithGoogle() async {
  //   try {
  //     await Auth.instance.signInWithGoogle();
  //   } catch (e) {
  //     if (e is FirebaseAuthException) {
  //       showErrorSnackBar('uh-oh!', e.message!, Get.context);
  //       debugPrint(e.message);
  //     } else {
  //       showErrorSnackBar('uh-oh!', e.toString(), Get.context);
  //     }
  //     formKey.value.currentState!.reset();
  //   }
  // }

  // String? passValidator(String pass) {
  //   int total = 0;
  //   List<List<String>> allChars = [specialChars, numbers, lowerCase, upperCase];
  //   for (int i = 0; i < allChars.length; i++) {
  //     for (int j = 0; j < allChars[i].length; j++) {
  //       if (pass.contains(allChars[i][j])) {
  //         total++;
  //         break;
  //       }
  //     }
  //   }
  //   if (total < 4) {
  //     return null;
  //   }
  //   return 'Password must contain at least 1 of each: special characters, numbers, lowercase letters, and uppercase letters';
  // }

  Stream<User?> get onAuthStateChanged => Auth.instance.auth.authStateChanges();

  final provideConfigs = [
    const EmailProviderConfiguration(),
    const GoogleProviderConfiguration(
      clientId: clientID,
    ),
  ];
}
