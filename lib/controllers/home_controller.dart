import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../services/auth.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  RxInt selectedTab = 0.obs;
  RxString? photoUrl = ''.obs;
  List<Widget> get tabs => [
        const Tab(
          text: 'Dashboard',
        ),
        const Tab(
          text: 'Flashcards',
        ),
        const Tab(
          text: 'Calendar',
        ),
        const Tab(
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

  @override
  void onReady() {
    super.onReady();
    if (Auth.instance.auth.currentUser != null) {
      Auth.instance.USER = AppUser(
          email: Auth.instance.auth.currentUser!.email!,
          uid: Auth.instance.auth.currentUser!.uid,
          name: Auth.instance.auth.currentUser!.displayName!,
          photoUrl: Auth.instance.auth.currentUser!.photoURL,
          phoneNumber: Auth.instance.auth.currentUser!.phoneNumber);
    }
  }
}
