// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts/app_colors.dart';

enum APPLOADINGSTATE {
  // ignore_for_file: constant_identifier_names
  ACTIVE,
  IDLE,
}

class LoadIndicator {
  // ignore: prefer_final_fields
  static Rx<APPLOADINGSTATE> _state = Rx<APPLOADINGSTATE>(APPLOADINGSTATE.IDLE);

  static void ON() {
    if (_state.value == APPLOADINGSTATE.IDLE) {
      _state.value = APPLOADINGSTATE.ACTIVE;
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kAccent),
            backgroundColor: Colors.grey,
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void OFF() {
    if (_state.value == APPLOADINGSTATE.ACTIVE) {
      _state.value = APPLOADINGSTATE.IDLE;
      Get.back();
    }
  }
}
