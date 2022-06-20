// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:studify/views/pages/timers_page/pomodoro.dart';
import '../../views/pages/bottom_nav_page/bottom_nav_bar.dart';
import '../../views/pages/timers_page/timer_homepage.dart';
import 'package:flutter/material.dart';
import 'package:studify/views/pages/calendar_page/calendar_page.dart';
import 'package:studify/views/pages/flashcard_page/flashcard_page.dart';
import '../../views/pages/dashboard_page/dashboard_page.dart';


class TimerController extends GetxController {
  String pomodoroIcon = 'assets/images/pomodoro_icon.svg';
  String stopwatchIcon = 'assets/images/stopwatch_icon.svg';
  String countdownIcon = 'assets/images/countdown_icon.svg';
  String presetTimers = 'assets/images/preset_timers.svg';
  String savedTimers = 'assets/images/saved_timers.svg';
  String timerStats = 'assets/images/timer_stats.svg';

  bool isRunning = false;
// this is just testing functionality that will be better implemented when the timer logic is more fleshed out
  void ScreensIfPomodoroActive() // if the Pomodoro timer is active, the timer homepage becomes the active timer itself in the navbar
  {
    if (isRunning == true) {
      BottomNavBarState.screens[2] = PomodoroTimer();
      BottomNavBarState.selectedIndex = 2;
    } else {
      BottomNavBarState.screens[2] = TimerHomePage();
    }
  }
}
