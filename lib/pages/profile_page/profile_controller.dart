import 'dart:ffi';

import 'package:get/get.dart';
import 'package:studify/widgets/snackbars/error_snackbar.dart';


class ProfileController extends GetxController {

  RxBool isEmailValid (String value) {
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      showErrorSnackBar('Error', 'Invalid email entered, please try again.', Get.context);
      return false.obs;
    }
    // Return null if the input is valid.
    return true.obs;
  }
}