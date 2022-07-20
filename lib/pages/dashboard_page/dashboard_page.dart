// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../themes/apptheme.dart';
import '../../utils/consts/app_colors.dart';
import '../../../services/auth.dart';
import '../home_page/home_controller.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  HomeController homeController = Get.put<HomeController>(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: kBackground,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                kBackgroundLight2,
                kBackgroundLight,
              ],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  left: 20,
                  top: 20,
                  child: Text(
                    'Dashboard',
                    style: GoogleFonts.ubuntu(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: accentColor.value,
                    ),
                  )),
            ],
          )),
    );
  }
}
