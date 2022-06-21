// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:studify/controllers/timer_controllers/pomodoro_history_controller.dart';
import 'package:studify/controllers/timer_controllers/timer_controller.dart';
import '../../models/pomodoro_models/pomodoro_history.dart';

class PomodoroController extends GetxController {
  late int workTime;
  int restTime = 0;
  int numOfCycles = 1;
  List<PomodoroHistory> pomodoroHistory = [];
  PomodoroHistoryController pomodoroHistoryController =
      PomodoroHistoryController();
  TimerController timerController = TimerController();
  late Timer pomodoroTimer;

  void startPomodoro() {
    const oneSecond = Duration(seconds: 1);
    pomodoroTimer = Timer.periodic(
      oneSecond,
      (Timer timer) {
        if (workTime <= 1) {
          pomodoroTimer.cancel();
          workTime = 0;
          timerController.isRunning.value = false;
          pomodoroHistory = pomodoroHistoryController.read('pomodoroHistory');
          pomodoroHistory.add(PomodoroHistory(
              dateTime: DateTime.now(),
              timeStudied: workTime,
              timeRested: restTime,
              cycles: numOfCycles));
          pomodoroHistoryController.save('pomodoroHistory', pomodoroHistory);
        }
        else {
          workTime--;
        }
      },
    );
  }

  @override
  void dispose()
  {
      pomodoroTimer.cancel();
      super.dispose();
  }
}
