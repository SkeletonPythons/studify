import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../services/auth.dart';
import '../routes/routes.dart';

class LoginController extends GetxController {
  AppUser? user;

  RxBool hidePW = true.obs;
  RxString email = ''.obs;
  RxString pass = ''.obs;

  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  Future<void> logIn(String email, String password) async {
    if (await Auth.login(email: email, password: password)) {
      user = await Auth.User;
      Get.offAndToNamed(Routes.HOME, arguments: user);
    } else {
      Get.snackbar('Error', 'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[300],
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          icon: const Icon(Icons.error, color: Colors.black));
    }
  }
}
