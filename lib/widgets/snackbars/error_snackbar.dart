import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void showErrorSnackBar(
  String title,
  String message,
  buildContext,
) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 5),
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color(0xff414141),
    borderRadius: 10,
    colorText: Colors.red[200],
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(10),
    icon: FaIcon(FontAwesomeIcons.explosion, color: Colors.red[400]),
  );
}
