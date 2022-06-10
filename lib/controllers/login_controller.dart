import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/services/db.dart';

import '../services/auth.dart';
import '../views/widgets/snackbars/error_snackbar.dart';

// import '../.secrets.dart';
import '../routes/routes.dart';
import '../models/user_model.dart';
import '../../../consts/app_colors.dart';

const String clientID =
    '620545516658-21ug7j0bajvrmlm7heht0lo5egmtdn7g.apps.googleusercontent.com';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  Stream<User?> get onAuthStateChanged => Auth.instance.auth.authStateChanges();

  @override
  void onInit() {
    super.onInit();
    Auth.instance.USER = AppUser(
        email: 'test@test.com',
        photoUrl: '',
        name: 'Testy Tester',
        uid: '00000');
    Auth.instance.auth.authStateChanges().listen((User? user) {
      if (Auth.instance.auth.currentUser != null) {
        Get.offAllNamed(Routes.NAVBAR);
      }
    });
  }

  RxBool obscurePass = true.obs;
  RxBool obscureConfirm = true.obs;
  RxBool signinScreen = true.obs;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void validate() {
    if (emailController.text != '' &&
        passwordController.text != '' &&
        confirmPasswordController.text != '' &&
        firstNameController.text != '' &&
        lastNameController.text != '') {
      if (passwordController.text == confirmPasswordController.text) {
        register(
          emailController.text.trim(),
          passwordController.text.trim(),
          firstNameController.text.trim(),
          lastNameController.text.trim(),
        );
      } else {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          icon: const Icon(Icons.error),
          backgroundColor: kAccent,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        icon: const Icon(Icons.error),
        backgroundColor: kAccent,
      );
    }
  }

  RxDouble opacity = 1.0.obs;

  late AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late Animation<double> animation =
      Tween(begin: 1.0, end: 0.0).animate(animationController);

  void transition() {
    animationController.addListener(() {
      opacity.value = animation.value;
      debugPrint(animation.value.toString());
    });
    animationController.forward().then((_) {
      signinScreen.toggle();
      animationController.reverse();
    });
  }

  void register(String first, last, email, pass) async {
    try {
      {
        await Auth.instance.auth
            .createUserWithEmailAndPassword(email: email, password: pass)
            .then(
          (user) async {
            await Auth.instance.auth.currentUser!.updateDisplayName(
              '$first $last',
            );

            Auth.instance.USER = AppUser(
              uid: user.user!.uid,
              email: user.user!.email!,
              name: user.user!.displayName!,
              photoUrl: user.user!.photoURL ??
                  '', // <- this sets the photoUrl to an empty string if it's null.
            );
            debugPrint(Auth.instance.USER.toJson().toString());
            Get.offAllNamed(Routes.HOME);
          },
        );
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

  void login(String email, String pass) async {
    try {
      {
        await Auth.instance.auth
            .signInWithEmailAndPassword(email: email, password: pass)
            .then(
          (user) {
            Auth.instance.USER = AppUser(
              uid: user.user!.uid,
              email: user.user!.email!,
              name: user.user!.displayName!,
              photoUrl: user.user!.photoURL,
            );
          },
        );
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

  AuthStateChangeAction<SignedIn> signedIn = AuthStateChangeAction<SignedIn>(
    (context, state) {
      if (state.user != null) {
        Get.offAllNamed(Routes.NAVBAR);
      }
    },
  );

  final provideConfigs = [
    const EmailProviderConfiguration(),
    const GoogleProviderConfiguration(
      clientId:
          '620545516658-21ug7j0bajvrmlm7heht0lo5egmtdn7g.apps.googleusercontent.com',
    ),
  ];
}
