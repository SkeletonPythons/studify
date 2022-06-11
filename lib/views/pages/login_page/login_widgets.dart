// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutterfire_ui/auth.dart';

import '../../../controllers/login_controller.dart';
import '../../../consts/app_colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final LoginController controller = Get.find();

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
      color: const Color(0xff313131),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign in',
              style: GoogleFonts.neucha().copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Log in to your account',
              style: GoogleFonts.neucha().copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Don\'t have an account?',
                  style: GoogleFonts.neucha().copyWith(fontSize: 18),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => controller.transition(),
                  child: Text(
                    'Register Now!',
                    style: GoogleFonts.neucha().copyWith(
                      fontSize: 18,
                      color: kAccent,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: kAccent,
            ),
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
            const Divider(
              color: kAccent,
            ),
            const GoogleSignInButton(clientId: clientID),
          ],
        ),
      ),
    );
  }
}

class RegisterScreenUI extends StatelessWidget {
  RegisterScreenUI({Key? key}) : super(key: key);
  final LoginController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
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
                style: GoogleFonts.neucha().copyWith(
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
                      onTap: () => _controller.transition(),
                      child: Text(
                        'Login!',
                        style: GoogleFonts.ubuntu().copyWith(
                          fontSize: 18,
                          color: kAccent,
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
                child: TextField(
                  onChanged: (value) => _controller.name.value = value,
                  controller: _controller.nameController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[200]!),
                      ),
                      labelText: 'Name',
                      labelStyle: GoogleFonts.neucha()),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.width * 0.8,
                // Email field
                child: TextField(
                  onChanged: (value) => _controller.email.value = value,
                  controller: _controller.emailController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[200]!),
                      ),
                      labelText: 'Email',
                      labelStyle: GoogleFonts.neucha()),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Get.width * 0.8,
                child: Obx(
                  () => TextField(
                    // Password field
                    onChanged: (value) => _controller.password.value = value,
                    controller: _controller.passwordController,
                    obscureText: _controller.obscurePass.value,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[200]!),
                      ),
                      labelText: 'Password',
                      suffixIcon: Obx(
                        () => IconButton(
                          onPressed: () => _controller.obscurePass.value =
                              !_controller.obscurePass.value,
                          icon: _controller.obscurePass.value
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
                  () => TextField(
                    // Confirm password field
                    onChanged: (value) =>
                        _controller.confirmPassword.value = value,
                    controller: _controller.confirmPasswordController,
                    obscureText: _controller.obscureConfirm.value,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue[200]!,
                        ),
                      ),
                      labelStyle: GoogleFonts.neucha(),
                      labelText: 'Confirm Password',
                      suffixIcon: Obx(
                        () => IconButton(
                          onPressed: () => _controller.obscureConfirm.value =
                              !_controller.obscureConfirm.value,
                          icon: _controller.obscureConfirm.value
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
                width: Get.width,
                height: Get.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    _controller.register(
                      _controller.name.value,
                      _controller.email.value,
                      _controller.password.value,
                      _controller.confirmPassword.value,
                    );
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
              const GoogleSignInButton(clientId: clientID),
            ]),
      ),
    );
  }
}
