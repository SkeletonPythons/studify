// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/views/pages/calendar_page/calendar_page.dart';
import 'package:studify/views/pages/demo_page/demo.dart';
import 'package:studify/views/pages/flashcard_page/flashcard_page.dart';
import 'package:studify/views/pages/dashboard_page/dashboard_page.dart';
import 'package:studify/views/pages/timers_page/timer_homepage.dart';
import '../../../controllers/home_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);
  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  HomeController homeController = Get.put<HomeController>(HomeController());

  // Controller widgets like PageController need to be disposed to avoid memory leaks.
  final List<Widget> _screens = [
    Dashboard(),
    CalendarPage(),
    TimerHomePage(),
    FlashcardPage(),
  ];
  int _selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    var homeIcon = 'assets/icons/home-outlined64x.png';
    var calendarIcon = 'assets/icons/calendar-outlined.png';
    var timersIcon = 'assets/icons/timer.png';
    var flashcardsIcon = 'assets/icons/flashcards.png';

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff414141),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        onTap: (index) => setState(() => _selectedIndex = index),
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
