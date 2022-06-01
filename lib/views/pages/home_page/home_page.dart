import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: TabBarView(
        children: <Widget>[Container()],
      ),
    );
  }
}
