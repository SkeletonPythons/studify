// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/controllers/timer_controllers/pomodoro_history_controller.dart';
import '../../models/pomodoro_models/pomodoro_history.dart';


class PomodoroController extends GetxController {
    int workTime = 0;
    int restTime = 0;
    int numOfCycles = 1;
    List<PomodoroHistory>  pomodoroHistory= [];
    PomodoroHistoryController pomodoroHistoryController = PomodoroHistoryController();
    late Timer pomodoroTimer;

void startPomodoro() {
    const oneSecond = Duration(seconds: 1);
    pomodoroTimer = Timer.periodic(oneSecond, (Timer timer) {
        if (workTime <= 1) {

        }
    },

    );
  }

}
