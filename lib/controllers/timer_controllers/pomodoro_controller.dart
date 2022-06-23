// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:studify/controllers/timer_controllers/pomodoro_history_controller.dart';
import 'package:studify/controllers/timer_controllers/timer_controller.dart';
import '../../models/pomodoro_models/pomodoro_history.dart';
import '../../views/pages/timers_page/timer_pomodoro_setup.dart';

class PomodoroController extends GetxController {
  RxInt workTime = 0.obs;
  int restTime = 0;
  int numOfCycles = 1;
  List<PomodoroHistory> pomodoroHistory = [];
  late Timer pomodoroTimer;

  TimerController timerController = TimerController();
  PomodoroHistoryController pomodoroHistoryController =
      PomodoroHistoryController();

  void startPomodoro() {
    const oneSecond = Duration(seconds: 1);
    pomodoroTimer = Timer.periodic(
      oneSecond,
      (Timer timer) {
        if (workTime <= 1) {
          pomodoroTimer.cancel();
          workTime.value = 0;
          timerController.isRunning.value = false;
          pomodoroHistory = pomodoroHistoryController.read('pomodoroHistory');
          pomodoroHistory.add(PomodoroHistory(
              dateTime: DateTime.now(),
              timeStudied: workTime.value,
              timeRested: restTime,
              cycles: numOfCycles));
          pomodoroHistoryController.save('pomodoroHistory', pomodoroHistory);
        } else {
          timerController.isRunning.value = true;
          workTime--;
        }
      },
    );
  }

  @override
  void dispose() {
    pomodoroTimer.cancel();
    super.dispose();
  }
}
