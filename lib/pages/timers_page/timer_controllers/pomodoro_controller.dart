// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/pages/timers_page/timer_controllers/history_controller.dart';
import 'package:studify/pages/timers_page/timer_pomodoro_setup.dart';

import '../../../models/pomodoro_models/history_model.dart';
import 'timer_controller.dart';

enum PomodoroStatus {
  running,
  pausedWork,
  pausedRest,
  resting,
  finished,
  cycleFinished
}

class PomodoroController extends GetxController {
  ///Functionality variables
  RxInt workTime = 0.obs;
  RxInt restTime = 0.obs;
  RxInt totalCycles = 0.obs;
  RxInt currentCycle = 0.obs;
  Rx<PomodoroStatus> currentPomodoroStatus = PomodoroStatus.running.obs;

  ///Status Maps
  Map<PomodoroStatus, String> displayStatus = {
    PomodoroStatus.running: "Study time!",
    PomodoroStatus.pausedWork: "Paused!",
    PomodoroStatus.pausedRest: "Paused!",
    PomodoroStatus.resting: "Rest time!",
    PomodoroStatus.finished: "Complete!",
    PomodoroStatus.cycleFinished: "Cycle Complete!"
  };

  Map<PomodoroStatus, Color> statusColors = {
    PomodoroStatus.running: Colors.green,
    PomodoroStatus.pausedWork: Colors.amber,
    PomodoroStatus.pausedRest: Colors.amber,
    PomodoroStatus.finished: Colors.red,
    PomodoroStatus.resting: Colors.blue
  };

  /// Get a list of timerFavorites from the database
  RxList<Pomodoro> get timerFavorites => <Pomodoro>[].obs;

  /// Get a list of timerFavorites from the database
  RxList<Pomodoro> get history {
    return <Pomodoro>[].obs;
  }

  static PomodoroController get instance => Get.find();

  @override
  void onInit() async {
    super.onInit();
    pomodoroFavorites = timerFavorites;
    pomodoroHistory = history;
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('pomodoroController/onReady');
  }

  ///History variables
  RxList<Pomodoro> pomodoroHistory = <Pomodoro>[].obs;
  RxList<Pomodoro> pomodoroFavorites = <Pomodoro>[].obs;
  late Timer pomodoroTimer;

  ///Controllers
  late TimerController timerController =
      Get.put<TimerController>(TimerController());
  HistoryController pomodoroHistoryController =
      Get.put<HistoryController>(HistoryController());

  /// Functions
  void StartPomodoro() {
    currentPomodoroStatus.value = PomodoroStatus.running;
    currentCycle.value = 0;



    ///Timer functionality
    const oneSecond = Duration(
      seconds: 1,
    );
    pomodoroTimer = Timer.periodic(
      oneSecond,
      (Timer timer) {
        if (workTime.value <= 1 && currentCycle.value == totalCycles.value) {
          pomodoroTimer.cancel();
          currentPomodoroStatus.value = PomodoroStatus.finished;
        } else if (currentPomodoroStatus.value == PomodoroStatus.running) {
          workTime.value--;
          if (workTime.value == 0) {
            SwitchToRest();
          }
        } else if (currentPomodoroStatus.value == PomodoroStatus.resting) {
          restTime.value--;
          if (restTime.value == 0) {
            UpdateCycles();
            SwitchToWork();
          }
        }
      },
    );
  }

  void StartPauseBtnPress() {
    switch (currentPomodoroStatus.value) {
      case PomodoroStatus.running:
        currentPomodoroStatus.value = PomodoroStatus.pausedWork;
        pomodoroTimer.cancel();
        timerController.isRunning.value = false;
        break;
      case PomodoroStatus.pausedWork:
        currentPomodoroStatus.value = PomodoroStatus.running;
        StartPomodoro();
        break;
      case PomodoroStatus.pausedRest:
        currentPomodoroStatus.value = PomodoroStatus.resting;
        StartPomodoro();
        break;
      case PomodoroStatus.resting:
        currentPomodoroStatus.value = PomodoroStatus.pausedRest;
        pomodoroTimer.cancel();
        break;
      case PomodoroStatus.cycleFinished:
        break;
      default:
        break;
    }
  }

  int DecideTimerDisplayValue() {
    if (currentPomodoroStatus.value == PomodoroStatus.running ||
        currentPomodoroStatus.value == PomodoroStatus.pausedWork) {
      return workTime.value;
    } else if (currentPomodoroStatus.value == PomodoroStatus.resting ||
        currentPomodoroStatus.value == PomodoroStatus.pausedRest) {
      return restTime.value;
    } else {
      return 0;
    }
  }

  double DecideMaxTime() {
    if (currentPomodoroStatus.value == PomodoroStatus.running ||
        currentPomodoroStatus.value == PomodoroStatus.pausedWork) {
      return (int.parse(PomodoroSetUpState.workTimeController.text) * 60)
          .toDouble();
    } else if (currentPomodoroStatus.value == PomodoroStatus.resting ||
        currentPomodoroStatus.value == PomodoroStatus.pausedRest) {
      return (int.parse(PomodoroSetUpState.restTimeController.text) * 60)
          .toDouble();
    } else {
      return 0.0;
    }
  }

  double DecideInitialSliderTimeValue() {
    if (currentPomodoroStatus.value == PomodoroStatus.running ||
        currentPomodoroStatus.value == PomodoroStatus.pausedWork) {
      debugPrint (workTime.value.toString());
      return workTime.value.toDouble();

    } else if (currentPomodoroStatus.value == PomodoroStatus.resting ||
        currentPomodoroStatus.value == PomodoroStatus.pausedRest) {
      return restTime.value.toDouble();
    } else {
      return 0.0;
    }
  }

  void StopBtnPress() {
    pomodoroTimer.cancel();
    PomodoroSetUpState.workTimeController.clear();
    PomodoroSetUpState.restTimeController.clear();
    PomodoroSetUpState.cycleController.clear();
  }

  void SwitchToRest() {
    if (workTime.value < 1 && currentCycle.value < totalCycles.value) {
      currentPomodoroStatus.value = PomodoroStatus.resting;
      if (currentCycle.value != totalCycles.value - 1) {
        ResetWorkTime();
      }
    }
  }

  void UpdateCycles() {
    if (currentCycle.value < totalCycles.value) {
      currentCycle++;
    }
  }

  void SwitchToWork() {
    if (restTime.value < 1 && currentCycle.value < totalCycles.value) {
      if (currentCycle.value != totalCycles.value) {
        currentPomodoroStatus.value = PomodoroStatus.running;
        ResetRestTime();
      }
    }
  }

  void ResetRestTime() {
    restTime.value = int.parse(PomodoroSetUpState.restTimeController.text) * 60;
  }

  void ResetWorkTime() {
    workTime.value = int.parse(PomodoroSetUpState.workTimeController.text) * 60;
  }

  String FormatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds - (minutes * 60);
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
