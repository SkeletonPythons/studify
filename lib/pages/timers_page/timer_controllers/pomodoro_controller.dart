// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../models/pomodoro_models/pomodoro_history.dart';
import 'pomodoro_history_controller.dart';
import 'timer_controller.dart';

enum PomodoroStatus { running, paused, stopped, rest, cycleFinished }

class PomodoroController extends GetxController {

  //Functionality variables
  RxInt workTime = 0.obs;
  RxInt restTime = 0.obs;
  RxInt totalCycles = 0.obs;
  RxInt currentCycle = 0.obs;


//Status Maps
  Map<PomodoroStatus,String > displayStatus = {
    PomodoroStatus.running:"Study time!",
    PomodoroStatus.paused: "Ready to continue?",
    PomodoroStatus.rest : "Time to relax, great job!",
    PomodoroStatus.cycleFinished : "Cycle Complete!"
  };

  Map<PomodoroStatus, Color> statusColors = {
    PomodoroStatus.running: Colors.red,
    PomodoroStatus.paused: Colors.deepOrange,
    PomodoroStatus.rest: Colors.white
  };

  //History variables
  List<PomodoroHistory> pomodoroHistory = [];
  late Timer pomodoroTimer;

  //Controllers
  late TimerController timerController =
      Get.put<TimerController>(TimerController());
  PomodoroHistoryController pomodoroHistoryController =
      Get.put<PomodoroHistoryController>(PomodoroHistoryController());

  // Functions
  void StartPomodoro() {
    const oneSecond = Duration(
      seconds: 1,
    );
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
              timeRested: restTime.value,
              cycles: totalCycles.value));
          pomodoroHistoryController.save('pomodoroHistory', pomodoroHistory);
        } else {
          timerController.isRunning.value = true;
          workTime.value--;
        }
      },
    );
  }

  void PausePomodoro() {
    pomodoroTimer.cancel();
    timerController.isRunning.value = false;
  }


  String FormatTime(int studyTimeInSeconds) {
    int minutes = workTime.value ~/ 60;
    int seconds = workTime.value - (minutes * 60);
    String secondsFormatted;
    String minutesFormatted;
    int hours = minutes ~/ 60;
    int minutesRemaining = minutes % 60;

    if (seconds < 10) {
      secondsFormatted = '0$seconds';
    } else {
      secondsFormatted = seconds.toString();
    }
    if (minutes >= 60) {
      minutesFormatted = '$minutesRemaining';
      return '$hours:$minutesFormatted:$secondsFormatted';
    } else {
      minutesFormatted = minutes.toString();
    }

    return '$minutesFormatted:$secondsFormatted';
  }

  @override
  void dispose() {
    pomodoroTimer.cancel();
    super.dispose();
  }
}
