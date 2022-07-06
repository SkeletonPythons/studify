// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/pages/timers_page/timer_pomodoro_setup.dart';

import '../../../models/pomodoro_models/pomodoro_history.dart';
import '../pomodoro.dart';
import 'pomodoro_history_controller.dart';
import 'timer_controller.dart';

enum PomodoroStatus { running, pausedWork, pausedRest, resting, finished, cycleFinished }

class PomodoroController extends GetxController {
  //Functionality variables
  RxInt workTime = 0.obs;
  RxInt restTime = 0.obs;
  RxInt totalCycles = 0.obs;
  RxInt currentCycle = 0.obs;
  Rx<PomodoroStatus> currentPomodoroStatus = PomodoroStatus.running.obs;

//Status Maps
  Map<PomodoroStatus, String> displayStatus = {
    PomodoroStatus.running: "Study time!",
    PomodoroStatus.pausedWork: "Paused!",
    PomodoroStatus.pausedRest: "Paused!",
    PomodoroStatus.resting: "Rest time!",
    PomodoroStatus.finished: "Pomodoros Complete!",
    PomodoroStatus.cycleFinished: "Cycle Complete!"
  };

  Map<PomodoroStatus, Color> statusColors = {
    PomodoroStatus.running: Colors.green,
    PomodoroStatus.pausedWork: Colors.amber,
    PomodoroStatus.pausedRest: Colors.amber,
    PomodoroStatus.finished: Colors.red,
    PomodoroStatus.resting: Colors.blue
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
        if (restTime.value <= 1 && currentCycle.value == totalCycles.value) {
          pomodoroTimer.cancel();
          currentPomodoroStatus.value = PomodoroStatus.finished;
          pomodoroHistory = pomodoroHistoryController.read('pomodoroHistory');
          pomodoroHistory.add(PomodoroHistory(
              dateTime: DateTime.now(),
              timeStudied: workTime.value,
              timeRested: restTime.value,
              cycles: totalCycles.value));
          pomodoroHistoryController.save('pomodoroHistory', pomodoroHistory);
        } else if (currentPomodoroStatus.value == PomodoroStatus.running){
            workTime.value--;
            SwitchToRest();
        } else if (currentPomodoroStatus.value == PomodoroStatus.resting){
            restTime.value--;
            SwitchToWork();
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

  int DecideTimerDisplayValue()
  {
    if(currentPomodoroStatus.value == PomodoroStatus.running || currentPomodoroStatus.value == PomodoroStatus.pausedWork)
    {
      return workTime.value;
    }
    else
    {
      return restTime.value;
    }
  }

  double DecideMaxTime()
  {
    if(currentPomodoroStatus.value == PomodoroStatus.running || currentPomodoroStatus.value == PomodoroStatus.pausedWork)
    {
      return (int.parse(PomodoroSetUpState.workTimeController.text) * 60).toDouble();
    }
    else
    {
      return (int.parse(PomodoroSetUpState.restTimeController.text) * 60).toDouble();
    }
  }

  double DecideInitialSliderTimeValue()
  {
    if(currentPomodoroStatus.value == PomodoroStatus.running || currentPomodoroStatus.value == PomodoroStatus.pausedWork)
    {
      return workTime.value.toDouble();
    }
    else
    {
      return restTime.value.toDouble();
    }
  }

  void StopBtnPress() {
    pomodoroTimer.cancel();
    PomodoroSetUpState.workTimeController.clear();
    PomodoroSetUpState.restTimeController.clear();
    PomodoroSetUpState.cycleController.clear();
  }

  void SwitchToRest()
  {
    if(workTime.value < 1 && currentCycle.value < totalCycles.value)
    {
      currentPomodoroStatus.value = PomodoroStatus.resting;
      if(currentCycle.value != totalCycles.value)
        {
          workTime.value = int.parse(PomodoroSetUpState.workTimeController.text) * 60;
        }
      else
        {
          workTime.value = 0;
        }
    }
  }

  void UpdateCycles()
  {
    if(currentCycle.value < totalCycles.value)
      {
        currentCycle++;
      }

  }

  void SwitchToWork()
  {
    if(restTime.value < 1 && currentCycle.value < totalCycles.value)
    {
      UpdateCycles();
      currentPomodoroStatus.value = PomodoroStatus.running;
      restTime.value = int.parse(PomodoroSetUpState.restTimeController.text) * 60;
    }
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
