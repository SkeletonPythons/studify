// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../pomodoro.dart';
import '../timer_homepage.dart';

class TimerController extends GetxController {
  static TimerController instance = Get.find<TimerController>();

  Rx<Widget> activeWidget = Rx<Widget>(TimerHomePage());
  String countdownIcon = 'assets/images/countdown_icon.svg';
  RxBool isRunning = false.obs;
  String pomodoroIcon = 'assets/images/pomodoro_icon.svg';
  String presetTimers = 'assets/images/preset_timers.svg';
  String savedTimers = 'assets/images/saved_timers.svg';
  String stopwatchIcon = 'assets/images/stopwatch_icon.svg';
  String timerStats = 'assets/images/timer_stats.svg';

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
