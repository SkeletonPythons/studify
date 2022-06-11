//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//
// App: Studify
// Team: Skeleton Pythons
// Author: Justin.Morton
// Date Created: 05/15/2022
// Last Modified By: Justin.Morton
// Last Modified Date: 05/15/2022
//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//
// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studify/views/widgets/loading_indicator.dart';

import '../models/user_model.dart';
import '../routes/routes.dart';
import '../views/widgets/snackbars/error_snackbar.dart';

class Auth extends GetxController {
  /// This is the Firebase Auth controller.
  /// It is used to handle the login and registration.
  /// It also contains the `user` object.
  /// Access this object by calling `Auth.instance.USER to get the user object.

  static final Auth instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  AppUser USER =
      AppUser(email: '', name: 'Default', photoUrl: '', uid: '00000');
  RxBool newUser = false.obs;
  RxBool isLoggedIn = false.obs;
  @override
  void onReady() {
    super.onReady();
    debugPrint('Auth onReady');
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _gateKeeper);
  }

  _gateKeeper(User? user) {
    if (user != null) {
      isLoggedIn.value = true;
      debugPrint('User is logged in');
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.offAllNamed(Routes.NAVBAR);
      });
      if (newUser.value) {
        debugPrint('User is new');
        return;
      }
    } else {
      debugPrint('User is not logged in');
    }
  }

  void signUpWithEmail(String email, String password) async {
    LoadIndicator.ON();
    try {
      debugPrint('Signing up with email');

      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        showErrorSnackBar('uh-oh!', e.message!, Get.context);
        debugPrint(e.message);
      } else {
        showErrorSnackBar('uh-oh!', e.toString(), Get.context);
      }
    }
  }

  void logInWithEmail(String email, String password) async {
    debugPrint('Logging in with email');

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        showErrorSnackBar('uh-oh!', e.message!, Get.context);
        debugPrint(e.message);
      } else {
        showErrorSnackBar('uh-oh!', e.toString(), Get.context);
      }
    }
  }

  void logOut() async {
    await auth.signOut();
  }
}
