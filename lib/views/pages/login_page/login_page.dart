import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animations/animations.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../consts/app_colors.dart';
import '../../../routes/routes.dart';
import '../../../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController _controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    Widget signin = AnimatedContainer(
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
              style: GoogleFonts.ubuntu().copyWith(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Log in to your account',
              style: GoogleFonts.ubuntu().copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Don\'t have an account?',
                  style: GoogleFonts.ubuntu().copyWith(fontSize: 18),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _controller.transition(),
                  child: Text(
                    'Register Now!',
                    style: GoogleFonts.ubuntu().copyWith(
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
              controller: _controller.emailController,
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
                controller: _controller.passwordController,
                obscureText: _controller.obscurePass.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[200]!),
                  ),
                  suffixIcon: Obx(
                    () => IconButton(
                      onPressed: () => _controller.obscurePass.value =
                          !_controller.obscurePass.value,
                      icon: _controller.obscurePass.value
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
                  _controller.login(_controller.emailController.text.trim(),
                      _controller.passwordController.text.trim());
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

    Widget registerUI = AnimatedContainer(
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
            const Text(
              'Register',
              style: TextStyle(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width * 0.4,
                  child: TextField(
                    controller: _controller.firstNameController,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[200]!),
                        ),
                        labelText: 'first name',
                        labelStyle: GoogleFonts.neucha()),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: Get.width * 0.4,
                  child: TextField(
                    controller: _controller.lastNameController,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[200]!),
                        ),
                        labelText: 'last name',
                        labelStyle: GoogleFonts.neucha()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.width * 0.8,
              child: TextField(
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
                  controller: _controller.confirmPasswordController,
                  obscureText: _controller.obscureConfirm.value,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
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
                  if (_controller.emailController.text != '' &&
                      _controller.passwordController.text != '' &&
                      _controller.confirmPasswordController.text != '' &&
                      _controller.firstNameController.text != '' &&
                      _controller.lastNameController.text != '') {
                    if (_controller.passwordController.text ==
                        _controller.confirmPasswordController.text) {
                      _controller.register(
                        _controller.emailController.text,
                        _controller.passwordController.text,
                        _controller.firstNameController.text,
                        _controller.lastNameController.text,
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
                },
                child: const Text('Register'),
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

    return Scaffold(
        backgroundColor: kBackground,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Obx(
            () => AnimatedOpacity(
              duration: const Duration(milliseconds: 3000),
              curve: Curves.fastOutSlowIn,
              opacity: _controller.opacity.value,
              child: Obx(() => Center(
                    child: _controller.signinScreen.value ? signin : registerUI,
                  )),
            ),
          ),
        )));
  }
}
