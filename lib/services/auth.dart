//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//
// App: Studify
// Team: Skeleton Pythons
// Author: Justin.Morton
// Date Created: 05/15/2022
//-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//
// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:studify/views/widgets/loading_indicator.dart';

import '../models/user_model.dart';
import '../routes/routes.dart';
import '../views/widgets/snackbars/error_snackbar.dart';
import './db.dart';

class Auth extends GetxController {
  /// This is the Firebase Auth controller.
  /// It is used to handle the login and registration.
  /// It also contains the `user` object.
  /// Access this object by calling `Auth.instance.USER to get the user object.

  static Auth get instance => Get.find();

  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;

  AppUser USER = AppUser(email: '', name: 'User', photoUrl: '', uid: '00000');

  RxBool newUser = false.obs;
  RxBool isLoggedIn = false.obs;
  RxBool isSplashDone = false.obs;

  @override
  void onReady() {
    super.onReady();
    debugPrint('Auth onReady');
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _gateKeeper);
  }

  void updateUser() {
    USER = AppUser(
      email: auth.currentUser!.email!,
      name: auth.currentUser!.displayName,
      photoUrl: auth.currentUser!.photoURL,
      uid: auth.currentUser!.uid,
    );
  }

  _gateKeeper(User? user) async {
    if (user != null) {
      Get.put(DB());
      updateUser();
      debugPrint(USER.toJson().toString());
      isLoggedIn.value = true;
      debugPrint('User is logged in');
      DB.instance.initDB();
      if (isSplashDone.value) {
        Get.offAllNamed(Routes.NAVBAR);
        return;
      } else {
        Future.delayed(const Duration(milliseconds: 4000), () {
          Get.offAllNamed(Routes.NAVBAR);
        });
      }
      if (newUser.value) {
        debugPrint('User is new');

        return;
      }
    } else {
      debugPrint('User is not logged in');
    }
  }

  Future<void> signUpWithEmail(
      {required String email,
      required String password,
      required String name}) async {
    LoadIndicator.ON();
    try {
      debugPrint('Signing up with email');

      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      USER.name = name;
      USER.email = email;
      USER.uid = auth.currentUser!.uid;
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
    isLoggedIn.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }
}
