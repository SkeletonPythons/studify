// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterfire_ui/auth.dart';

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
                      color: kAccent,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: kAccent, thickness: 2),
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
                          : const FaIcon(FontAwesomeIcons.solidEye,
                              color: kAccent, size: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: kAccent,
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
                child: const Text('Sign in'),
              ),
            ),
            GoogleSignInButton(
                clientId: clientID,
                auth: Auth.instance.auth,
                action: AuthAction.signIn),
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
              const Divider(
                color: kAccent,
                thickness: 2,
              ),
              SizedBox(
                width: Get.width * 0.8,
                // Display name field
                child: Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) => controller.validateName(value),
                        onChanged: (value) => controller.name.value = value,
                        controller: controller.nameController,
                        decoration: InputDecoration(
                            prefixIcon: const FaIcon(FontAwesomeIcons.user,
                                color: kAccent, size: 20),
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
                              prefixIcon: const FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: kAccent,
                                  size: 20),
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
                              prefixIcon: const FaIcon(FontAwesomeIcons.lock,
                                  color: kAccent, size: 20),
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
                                      : const FaIcon(FontAwesomeIcons.solidEye,
                                          color: kAccent, size: 20),
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
                              prefixIcon: const FaIcon(FontAwesomeIcons.lock,
                                  color: kAccent, size: 20),
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
                                      : const FaIcon(FontAwesomeIcons.solidEye,
                                          color: kAccent, size: 20),
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
                    if (controller.formKey.currentState!.validate()) {
                      controller.register(
                        controller.name.value,
                        controller.email.value,
                        controller.password.value,
                        controller.confirmPassword.value,
                      );
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
              const Divider(
                color: kAccent,
                thickness: 3,
              ),
              GoogleSignInButton(
                clientId: clientID,
                auth: Auth.instance.auth,
                action: AuthAction.signUp,
              ),
            ]),
      ),
    );
  }
}
