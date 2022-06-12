// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/auth.dart';
import '../../../controllers/home_controller.dart';
import 'package:studify/views/widgets/app_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  HomeController homeController = Get.put<HomeController>(HomeController());

  @override
  Widget build(BuildContext context) {
    if (Auth.instance.USER.photoUrl == null ||
        Auth.instance.USER.photoUrl == '') {
      homeController.photoUrl?.value = '';
    } else {
      homeController.photoUrl?.value = Auth.instance.USER.photoUrl!;
    }
    var sideMenuIcon = 'assets/icons/menu-burger.png';
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xff313131),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: DefaultAppBar(),
      ),
    );
  }
}
