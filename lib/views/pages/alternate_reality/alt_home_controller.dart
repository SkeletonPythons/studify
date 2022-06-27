// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/consts/app_colors.dart';
// import '../../pages/dashboard_page/dashboard_page.dart';
import '../../../controllers/flashcard_controller.dart';
import '../../pages/calendar_page/calendar_page.dart';
import '../../pages/flashcard_page/flashcard_page.dart';
import '../../pages/timers_page/timer_homepage.dart';
import './alt_home.dart';

class AltHomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt currentIndex = 0.obs;
  late TabController tabController;

  final GlobalKey<ScaffoldState> altScaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> tabViews = [
    const AltDashboard(),
    const CalendarPage(),
    const TimerHomePage(),
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

  List<FloatingActionButton?> fabs = [
    FloatingActionButton.large(
        onPressed: () => Get.snackbar(
            'Hey!', 'This is the dashboard\'s floating action button!')),
    FloatingActionButton.extended(
        onPressed: () => Get.snackbar(
              'So....',
              'What do you think of the calendar\'s floating action button?',
            ),
        label: const Text('Calendar FAB')),
    FloatingActionButton.small(
      onPressed: () {
        Get.snackbar('Hey!', 'This is the timers\'s floating action button!');
      },
    ),
    FloatingActionButton(onPressed: () {
      Get.find<FlashcardController>()
          .notes
          .add(Get.find<FlashcardController>().createNote());
      Get.snackbar('WooHoo!', 'New Note Created!');
    }),
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
