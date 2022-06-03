import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../routes/routes.dart';
import '../views/widgets/snackbars/error_snackbar.dart';

class LoginController extends GetxController {
  RxBool hidePW = true.obs;
  RxString email = ''.obs;
  RxString pass = ''.obs;

  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  Future<void> logIn() async {
    try {
      Auth.instance.logInWithEmail(email.value.trim(), pass.value.trim());
    } catch (e) {
      if (e is FirebaseAuthException) {
        showErrorSnackBar('uh-oh!', e.message!, Get.context);
        debugPrint(e.message);
      } else {
        showErrorSnackBar('uh-oh!', e.toString(), Get.context);
      }
      formKey.value.currentState!.reset();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      await Auth.instance.signInWithGoogle();
    } catch (e) {
      if (e is FirebaseAuthException) {
        showErrorSnackBar('uh-oh!', e.message!, Get.context);
        debugPrint(e.message);
      } else {
        showErrorSnackBar('uh-oh!', e.toString(), Get.context);
      }
      formKey.value.currentState!.reset();
    }
  }

  List<String> specialChars = [
    '!',
    '@',
    '#',
    '\$',
    '%',
    '^',
    '&',
    '*',
    '(',
    ')',
    '_',
    '+',
    '=',
    '{',
    '}',
    '[',
    ']',
    '|',
    ':',
    ';',
    '"',
    '<',
    '>',
    '?',
    '~',
    '`',
    '.',
    '/',
    '\\',
    ' '
  ];
  List<String> numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List<String> lowerCase = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  List<String> upperCase = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  String? emailValidator(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value.length < 6 || value.isEmpty || !regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }

  String? passValidator(String pass) {
    int total = 0;
    List<List<String>> allChars = [specialChars, numbers, lowerCase, upperCase];
    for (int i = 0; i < allChars.length; i++) {
      for (int j = 0; j < allChars[i].length; j++) {
        if (pass.contains(allChars[i][j])) {
          total++;
          break;
        }
      }
    }
    if (total < 4) {
      return null;
    }
    return 'Password must contain at least 1 of each: special characters, numbers, lowercase letters, and uppercase letters';
  }
}
