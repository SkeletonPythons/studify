import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../services/auth.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  RxInt selectedTab = 0.obs;
  RxString? photoUrl = ''.obs;
  List<Widget> get tabs => [
        Tab(
          text: 'Dashboard',
        ),
        Tab(
          text: 'Flashcards',
        ),
        Tab(
          text: 'Calendar',
        ),
        Tab(
          text: 'Timer',
        ),
      ];

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(
      length: tabs.length,
      vsync: this,
      animationDuration: const Duration(milliseconds: 500),
      initialIndex: selectedTab.value,
    );
  }
}
