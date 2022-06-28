// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/routes/routes.dart';
import '../../../controllers/timer_controllers/timer_controller.dart';
import '../../../views/pages/calendar_page/calendar_page.dart';
import '../../../views/pages/flashcard_page/flashcard_page.dart';
import '../../../views/pages/dashboard_page/dashboard_page.dart';
import '../../../views/pages/timers_page/timer_homepage.dart';
import '../../../views/widgets/app_bar.dart';
import '../../../controllers/home_controller.dart';
import '../../../services/auth.dart';

class NavBarController extends GetxController
with GetSingleTickerProviderStateMixin {
  static RxInt currentIndex = 0.obs;
  late TabController tabController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static List<Widget> tabViews = [
    Dashboard(),
    CalendarPage(),
    TimerHomePage(),
    FlashcardPage(),
  ];

  final List<Widget> tabs = [
    Tab(
      icon: Image.asset(
        'assets/icons/home-outlined64x.png',
        width: 35,
        height: 35,
      ),
      child: Text(
        'Home',
        style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.white),
      ),
    ),
    Tab(
      icon: Image.asset(
        'assets/icons/calendar-outlined.png',
        width: 35,
        height: 35,
      ),
      child: Text(
        'Calendar',
        style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.white),
      ),
    ),
    Tab(
      icon: Image.asset(
        'assets/icons/timer.png',
        width: 35,
        height: 35,
      ),
      child: Text(
        'Timers',
        style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.white),
      ),
    ),
    Tab(
      icon: Image.asset(
        'assets/icons/flashcards.png',
        width: 35,
        height: 35,
      ),
      child: Text(
        'Flashcards',
        style: GoogleFonts.ubuntu(fontSize: 12, color: Colors.white),
      ),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabViews.length, vsync: this);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
      update();
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}