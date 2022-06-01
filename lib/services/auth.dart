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
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../routes/routes.dart';
import '../views/widgets/snackbars/error_snackbar.dart';

class Auth extends GetxController {
  /// This is the Firebase Auth controller.
  /// It is used to handle the login and registration.
  /// It also contains the `user` object.
  /// Access this object by calling `Auth.instance.<WHAT YOU WANT TO ACCESS>

  static final Auth instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxString initialRoute = Routes.LOGIN.obs;
  late AppUser USER;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _gateKeeper);
  }

  /// Checks if user is persisted in the app. If so, it will route to the home page.
  /// If not, it will route to the login page.
  _gateKeeper(User? user) {
    if (user != null) {
      debugPrint('User is logged in');
      initialRoute.value = Routes.HOME;
    } else {
      debugPrint('User is not logged in going to ');
      initialRoute.value = Routes.LOGIN;
    }
  }

  void signUpWithEmail(String email, String password) async {
    try {
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
    try {
      populateUser(await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ));
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

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      populateUser(await auth.signInWithCredential(credential));
    } catch (e) {
      if (e is FirebaseAuthException) {
        showErrorSnackBar('uh-oh!', e.message!, Get.context);
        debugPrint(e.message);
      } else {
        showErrorSnackBar('uh-oh!', e.toString(), Get.context);
      }
    }
  }

  void populateUser(UserCredential? cred) {
    debugPrint('populating user');
    if (cred != null) {
      USER = AppUser(
        uid: cred.user!.uid,
        name: cred.user!.displayName!,
        email: cred.user!.email!,
        photoUrl: cred.user!.photoURL,
        isVerified: cred.user!.emailVerified,
        phoneNumber: cred.user!.phoneNumber,
      );
    }
  }
}
