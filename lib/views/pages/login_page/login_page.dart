import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/consts/colors.dart';

import '../../../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return _controller.user == null
        ?
        // If the user is null, show the login page.
        Material(
            child: Container(
              height: Get.height,
              width: Get.width,
              color: kBackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          color: kPrimary,
                        ),
                      )
                    ],
                  ),
                  Obx(() => Form(
                        key: _controller.formKey.value,
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (newValue) =>
                                  _controller.email.value = newValue!,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                              ),
                              validator: (String? value) {
                                if (value == null) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            Obx(
                              () => TextFormField(
                                  onSaved: (newValue) =>
                                      _controller.pass.value = newValue!,
                                  obscureText: _controller.hidePW.value,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your password',
                                    icon: !_controller.hidePW.value
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                  ),
                                  validator: (String? value) {
                                    if (value == null) {
                                      return 'Password cannot be blank!';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                      )),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_controller.formKey.value.currentState!
                              .validate()) {
                            _controller.formKey.value.currentState!.save();
                            _controller.logIn(_controller.email.value,
                                _controller.pass.value);
                            _controller.formKey.value.currentState!.reset();
                          }
                        },
                        child: const Text('login'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        // If user is not null then continue to the home page.
        : Container();
  }
}
