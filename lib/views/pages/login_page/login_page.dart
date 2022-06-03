import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/consts/app_colors.dart';
import 'package:studify/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: Get.height,
          width: Get.width,
          color: kBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.7,
                    height: Get.height * 0.2,
                  ),
                  const Text(
                    'login',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: kAccent,
                    ),
                  )
                ],
              ),
              Form(
                key: _controller.formKey.value,
                child: Column(
                  children: [
                    SizedBox(
                      width: Get.width * 0.7,
                      height: Get.height * 0.05,
                      child: TextFormField(
                        cursorColor: kAccent,
                        minLines: 1,
                        style: const TextStyle(
                          fontSize: 20,
                          color: kAccent,
                        ),
                        onSaved: (newValue) =>
                            _controller.email.value = newValue!,
                        decoration: const InputDecoration(
                          focusColor: kAccent,
                          hintText: 'Enter your email',
                        ),
                        validator: (String? value) =>
                            _controller.emailValidator(value!),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.7,
                      height: Get.height * 0.05,
                      child: TextFormField(
                          onSaved: (newValue) =>
                              _controller.pass.value = newValue!,
                          obscureText: _controller.hidePW.value,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            suffixIcon: IconButton(
                              icon: Obx(
                                () => Icon(
                                  _controller.hidePW.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              onPressed: () => _controller.hidePW.value =
                                  !_controller.hidePW.value,
                            ),
                          ),
                          validator: (String? value) =>
                              _controller.passValidator(value!.trim())),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Get.width,
                child: Padding(
                  padding: EdgeInsets.only(right: Get.width * .15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Forgot your password?',
                        style: TextStyle(color: kTextColor),
                      ),
                      TextButton(
                        onPressed: () => Get.offAndToNamed(Routes
                            .LOGIN /*TODO: CHANGE THIS TO REGISTER PAGE*/),
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: kAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.2,
                    vertical: Get.height * 0.02,
                  ),
                ),
                onPressed: () {
                  if (_controller.formKey.value.currentState!.validate()) {
                    _controller.formKey.value.currentState!.save();
                    debugPrint(_controller.email.value);
                    _controller.logIn();
                    _controller.formKey.value.currentState!.reset();
                  }
                },
                child: const Text('login'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: kTextColor),
                  ),
                  TextButton(
                    onPressed: () => Get.offAndToNamed(
                        Routes.LOGIN /*TODO: CHANGE THIS TO REGISTER PAGE*/),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: kAccent),
                    ),
                  )
                ],
              ),
              const Divider(color: kAccent),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'or login with',
                    style: TextStyle(color: kTextColor),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google,
                        color: Colors.lightBlueAccent),
                    onPressed: () {
                      _controller.logInWithGoogle();
                    },
                  ),
                ],
              ),
            ],
          )),
    );
    // If user is not null then continue to the home page.
  }
}
