// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:studify/controllers/navbar_controller.dart';
import 'package:studify/views/pages/timers_page/pomodoro.dart';
import '../../views/pages/bottom_nav_page/OLD_navbar.dart';
import '../../views/pages/timers_page/timer_homepage.dart';
import 'package:flutter/material.dart';
import 'package:studify/views/pages/calendar_page/calendar_page.dart';
import 'package:studify/views/pages/flashcard_page/flashcard_page.dart';
import '../../views/pages/dashboard_page/dashboard_page.dart';

class TimerController extends GetxController {
  static TimerController instance = Get.find<TimerController>();
  String pomodoroIcon = 'assets/images/pomodoro_icon.svg';
  String stopwatchIcon = 'assets/images/stopwatch_icon.svg';
  String countdownIcon = 'assets/images/countdown_icon.svg';
  String presetTimers = 'assets/images/preset_timers.svg';
  String savedTimers = 'assets/images/saved_timers.svg';
  String timerStats = 'assets/images/timer_stats.svg';

  RxBool isRunning = false.obs;

  Rx<Widget> activeWidget = Rx<Widget>(TimerHomePage());
// this is just testing functionality that will be better implemented when the timer logic is more fleshed out
  void
      ScreensIfPomodoroActive() // if the Pomodoro timer is active, the timer homepage becomes the active timer itself in the navbar
  {
    if (isRunning.value == true) {
      activeWidget.value = PomodoroTimer();
    } else {
      activeWidget.value = TimerHomePage();
    }
  }

  void setActiveWidget(Widget widget) {
    activeWidget.value = widget;
  }
}
