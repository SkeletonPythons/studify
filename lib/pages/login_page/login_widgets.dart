// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterfire_ui/auth.dart';

import '../../global_controller.dart';
import '../../services/auth.dart';
import '../../utils/consts/app_colors.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen(this.controller, {Key? key}) : super(key: key);
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      height: Get.height,
      width: Get.width,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      color: kBackground,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign in',
              style: GoogleFonts.ubuntuCondensed().copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Log in to your account',
              style: GoogleFonts.ubuntuCondensed().copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Don\'t have an account?',
                  style: GoogleFonts.ubuntuCondensed().copyWith(fontSize: 18),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    controller.transition();
                  },
                  child: Text(
                    'Register Now!',
                    style: GoogleFonts.ubuntuCondensed().copyWith(
                      fontSize: 18,
                      color: GC.accent.value,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: GC.accent.value, thickness: 2),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[200]!),
                ),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => TextField(
                controller: controller.passwordController,
                obscureText: controller.obscurePass.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[200]!),
                  ),
                  suffixIcon: Obx(
                    () => IconButton(
                      onPressed: () => controller.obscurePass.value =
                          !controller.obscurePass.value,
                      icon: controller.obscurePass.value
                          ? const FaIcon(FontAwesomeIcons.solidEyeSlash,
                              color: Colors.white54, size: 20)
                          : FaIcon(FontAwesomeIcons.solidEye,
                              color: GC.accent.value, size: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Divider(
              color: GC.accent.value,
              thickness: 2,
            ),
            SizedBox(
              width: Get.width,
              height: Get.height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  controller.login(controller.emailController.text.trim(),
                      controller.passwordController.text.trim());
                },
                child: Text('Sign in with email/password',
                    style: GoogleFonts.roboto().copyWith(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            const CustomGoogleButton(action: AuthAction.signIn)
          ],
        ),
      ),
    );
  }
}

class RegisterScreenUI extends StatelessWidget {
  const RegisterScreenUI(this.controller, {Key? key}) : super(key: key);
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff313131),
      ),
      height: Get.height,
      width: Get.width,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: GoogleFonts.ubuntuCondensed().copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Register as a new user...',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.width * 0.8,
                child: Row(
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.ubuntu().copyWith(fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => controller.transition(),
                      child: Text(
                        'Login!',
                        style: GoogleFonts.ubuntu().copyWith(
                          fontSize: 18,
                          color: Colors.amber[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: GC.accent.value,
                thickness: 2,
              ),
              SizedBox(
                width: Get.width * 0.8,
                // Display name field
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) => controller.validateName(value),
                        onChanged: (value) => controller.name.value = value,
                        controller: controller.nameController,
                        decoration: InputDecoration(
                            prefixIcon: FaIcon(FontAwesomeIcons.user,
                                color: GC.accent.value, size: 20),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[200]!),
                            ),
                            labelText: 'Name',
                            labelStyle: GoogleFonts.ubuntuCondensed()),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: Get.width * 0.8,
                        // Email field
                        child: TextFormField(
                          validator: (value) => controller.validateEmail(value),
                          onChanged: (value) => controller.email.value = value,
                          controller: controller.emailController,
                          decoration: InputDecoration(
                              prefixIcon: FaIcon(FontAwesomeIcons.envelope,
                                  color: GC.accent.value, size: 20),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue[200]!),
                              ),
                              labelText: 'Email',
                              labelStyle: GoogleFonts.ubuntuCondensed()),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: Get.width * 0.8,
                        child: Obx(
                          () => TextFormField(
                            // Password field
                            validator: (value) =>
                                controller.validatePassword(value),

                            onChanged: (value) =>
                                controller.password.value = value,
                            controller: controller.passwordController,
                            obscureText: controller.obscurePass.value,
                            decoration: InputDecoration(
                              prefixIcon: FaIcon(FontAwesomeIcons.lock,
                                  color: GC.accent.value, size: 20),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue[200]!),
                              ),
                              labelText: 'Password',
                              suffixIcon: Obx(
                                () => IconButton(
                                  onPressed: () => controller.obscurePass
                                      .value = !controller.obscurePass.value,
                                  icon: controller.obscurePass.value
                                      ? const FaIcon(
                                          FontAwesomeIcons.solidEyeSlash,
                                          color: Colors.white54,
                                          size: 20,
                                        )
                                      : FaIcon(FontAwesomeIcons.solidEye,
                                          color: GC.accent.value, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: Get.width * 0.8,
                        child: Obx(
                          () => TextFormField(
                            validator: (value) =>
                                controller.validateConfirmPassword(value),
                            // Confirm password field
                            onChanged: (value) =>
                                controller.confirmPassword.value = value,
                            controller: controller.confirmPasswordController,
                            obscureText: controller.obscureConfirm.value,
                            decoration: InputDecoration(
                              prefixIcon: FaIcon(FontAwesomeIcons.lock,
                                  color: GC.accent.value, size: 20),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue[200]!,
                                ),
                              ),
                              labelStyle: GoogleFonts.ubuntuCondensed(),
                              labelText: 'Confirm Password',
                              suffixIcon: Obx(
                                () => IconButton(
                                  onPressed: () => controller.obscureConfirm
                                      .value = !controller.obscureConfirm.value,
                                  icon: controller.obscureConfirm.value
                                      ? const FaIcon(
                                          FontAwesomeIcons.solidEyeSlash,
                                          color: Colors.white54,
                                          size: 20,
                                        )
                                      : FaIcon(FontAwesomeIcons.solidEye,
                                          color: GC.accent.value, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                height: Get.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    String? emailError = controller
                        .validateEmail(controller.emailController.text);
                    String? passError = controller
                        .validatePassword(controller.passwordController.text);
                    String? nameError =
                        controller.validateName(controller.nameController.text);
                    String? confirmError = controller.validateConfirmPassword(
                        controller.confirmPasswordController.text);
                    if (emailError == null &&
                        passError == null &&
                        nameError == null &&
                        confirmError == null) {
                      controller.register(
                        controller.name.value,
                        controller.email.value,
                        controller.password.value,
                        controller.confirmPassword.value,
                      );
                    } else {
                      if (emailError != null) {
                        Get.snackbar(
                          'Error',
                          emailError,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      }
                      if (passError != null) {
                        Get.snackbar(
                          'Error',
                          passError,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      }
                      if (nameError != null) {
                        Get.snackbar(
                          'Error',
                          nameError,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      }
                      if (confirmError != null) {
                        Get.snackbar(
                          'Error',
                          confirmError,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Sign up!',
                    style: GoogleFonts.ubuntu().copyWith(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Divider(
                color: GC.accent.value,
                thickness: 3,
              ),
              const SizedBox(height: 20),
              const CustomGoogleButton(
                action: AuthAction.signUp,
              ),
            ]),
      ),
    );
  }
}

enum BtnState { normal, disabled, focused, pressed }

class CustomGoogleButton extends StatefulWidget {
  const CustomGoogleButton({required this.action, Key? key}) : super(key: key);

  final AuthAction action;

  @override
  State<CustomGoogleButton> createState() => _CustomGoogleButtonState();
}

class _CustomGoogleButtonState extends State<CustomGoogleButton> {
  Rx<BtnState> btnState = BtnState.normal.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.05,
      width: Get.width,
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
            backgroundColor:
                MaterialStateProperty.all(const Color(0xff4285f4))),
        onHover: (value) {
          if (value) {
            btnState.value = BtnState.focused;
          } else {
            btnState.value = BtnState.normal;
          }
        },
        onPressed: () async {
          if (btnState.value == BtnState.normal) {
            btnState.value = BtnState.pressed;
            Future.delayed(
              const Duration(milliseconds: 100),
              () {
                btnState.value = BtnState.normal;
              },
            );
          }
          await Auth.instance.logInWithGoogle();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(5),
                    bottomStart: Radius.circular(5)),
              ),
              child: Image.asset(btnState.value == BtnState.disabled
                  ? 'assets/images/g.png'
                  : btnState.value == BtnState.focused
                      ? 'assets/images/g.png'
                      : btnState.value == BtnState.pressed
                          ? 'assets/images/g.png'
                          : 'assets/images/g.png'),
            ),
            const SizedBox(width: 10),
            Text(
              widget.action == AuthAction.signIn
                  ? 'Sign in with Google!'
                  : 'Register with Google!',
              style: GoogleFonts.roboto().copyWith(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
