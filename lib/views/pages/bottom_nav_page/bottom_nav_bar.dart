// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/controllers/timer%20controllers/timer_controller.dart';
import 'package:studify/views/pages/calendar_page/calendar_page.dart';
import 'package:studify/views/pages/flashcard_page/flashcard_page.dart';
import 'package:studify/views/pages/dashboard_page/dashboard_page.dart';
import 'package:studify/views/pages/timers_page/timer_homepage.dart';
import 'package:studify/views/widgets/app_bar.dart';
import '../../../controllers/home_controller.dart';
import '../timers_page/pomodoro.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);
  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  HomeController homeController = Get.put<HomeController>(HomeController());
  TimerController timerController = Get.put<TimerController>(TimerController());

  /*made screen and selectedIndex static in order to access them from other
  controllers/classes in case page order needs to change*/

  static List<Widget> screens = [
    Dashboard(),
    CalendarPage(),
    TimerHomePage(),
    FlashcardPage(),
  ];
  static int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var homeIcon = 'assets/icons/home-outlined64x.png';
    var calendarIcon = 'assets/icons/calendar-outlined.png';
    var timersIcon = 'assets/icons/timer.png';
    var flashcardsIcon = 'assets/icons/flashcards.png';

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), child: DefaultAppBar()),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff414141),
        currentIndex: selectedIndex,
        selectedItemColor: Colors.redAccent,
        onTap: (index) => setState(() => selectedIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                homeIcon,
                width: 35,
                height: 35,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Image.asset(
                calendarIcon,
                width: 35,
                height: 35,
              ),
              label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Image.asset(
                timersIcon,
                width: 35,
                height: 35,
              ),
              label: 'Timers'),
          BottomNavigationBarItem(
              icon: Image.asset(
                flashcardsIcon,
                width: 35,
                height: 35,
              ),
              label: 'Flashcards'),
        ],
      ),
    );
  }
}
