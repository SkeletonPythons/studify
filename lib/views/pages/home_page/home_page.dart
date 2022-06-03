import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: TabBarView(
            controller: _homeController.tabController,
            children: _homeController.tabs,
          ),
        ),
      ),
    );
  }
}
