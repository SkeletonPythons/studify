import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  late AppUser user;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 0, vsync: this);
    user = Get.arguments['AppUser'];
  }
}
