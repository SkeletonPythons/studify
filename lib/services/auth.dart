// ---
// App: Studify
// Team: Skeleton Pythons
// Author: Justin.Morton
// Date Created: 05/15/2022
// ---
// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/loading_indicator.dart';
import '../models/user_model.dart';
import '../routes/routes.dart';
import '../widgets/snackbars/error_snackbar.dart';
import './db.dart';

class Auth extends GetxController {
  /// This is the Firebase Auth controller.
  /// It is used to handle the login and registration.
  /// It also contains the `user` object.
  /// Access this object by calling `Auth.instance.USER to get the user object.

  static Auth get instance => Get.find();

  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;

  late AppUser USER = AppUser(email: '', name: 'User', photoUrl: '', uid: '');

  RxBool newUser = false.obs;
  RxBool isLoggedIn = false.obs;
  RxBool isSplashDone = false.obs;

  @override
  void onReady() {
    super.onReady();
    debugPrint('Auth onReady');
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, _gateKeeper);
  }

  void updateUser() {
    USER
      ..email = auth.currentUser!.email!
      ..name = auth.currentUser!.displayName
      ..photoUrl = auth.currentUser!.photoURL ?? ''
      ..uid = auth.currentUser!.uid;
  }

  _gateKeeper(User? user) async {
    LoadIndicator.ON();
    if (user != null) {
      updateUser();
      Get.put<DB>(DB(), permanent: true);
      isLoggedIn.value = true;
      debugPrint('User is logged in');
      DB.instance.initDB();
      await Future.delayed(const Duration(seconds: 2), () {
        LoadIndicator.OFF();
        Get.offAllNamed(Routes.NAVBAR);
      });
    } else {
      debugPrint('User is not logged in');
      Get.offAndToNamed(Routes.LOGIN);
    }
  }

  Future<void> signUpWithEmail(
      {required String email,
      required String password,
      required String name}) async {
    LoadIndicator.ON();
    try {
      debugPrint('Signing up with email');
      newUser.value = true;
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      newUser.value = true;
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
      newUser.value = false;
    } catch (e) {
      if (e is FirebaseAuthException) {
        showErrorSnackBar('uh-oh!', e.message!, Get.context);
        debugPrint(e.message);
      } else {
        showErrorSnackBar('uh-oh!', e.toString(), Get.context);
      }
    }
  }

  Future<User?> logInWithGoogle() async {
    debugPrint('Logging in with google');
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential

      try {
        UserCredential result = await auth.signInWithCredential(authCredential);
        user = result.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here

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
    return user;
  }

  void logout() async {
    await auth.signOut();
    isLoggedIn.value = false;
  }
}
