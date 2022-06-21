// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:studify/controllers/timer_controllers/pomodoro_controller.dart';
import 'package:studify/controllers/timer_controllers/timer_controller.dart';
import 'package:studify/views/pages/timers_page/timer_pomodoro_setup.dart';
import '../../../controllers/timer_controllers/pomodoro_history_controller.dart';
import '../../../models/pomodoro_models/pomodoro_history.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({Key? key}) : super(key: key);

  @override
  PomodoroTimerState createState() => PomodoroTimerState();
}

class PomodoroTimerState extends State<PomodoroTimer>
    with SingleTickerProviderStateMixin {
  PomodoroController pomodoroController =
      Get.put<PomodoroController>(PomodoroController());
  PomodoroHistoryController pomodoroHistoryController =
      Get.put<PomodoroHistoryController>(PomodoroHistoryController());
  TimerController timerController = Get.put<TimerController>(TimerController());

  double workTime = PomodoroSetUpState.workTime.toDouble();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 500,
              height: 500,
              child: Stack(children: [
                if (timerController.isRunning.value)
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 250,
                      height: 250,
                      color: Colors.transparent,
                    ),
                  ),
                Positioned(
                  top: 100,
                  left: 47,
                  child: SleekCircularSlider(
                    initialValue: workTime
                        .toDouble(), // I can't extract this value from the controller,
                    // however I can extract it from inside timersetupstate,
                    // need help with state management from the controllers
                    min: 0,
                    max: 5401,
                    appearance: CircularSliderAppearance(
                      size: 300,
                      customWidths: CustomSliderWidths(
                        trackWidth: 15,
                        handlerSize: 18,
                        progressBarWidth: 15,
                        shadowWidth: 0,
                      ),
                      customColors: CustomSliderColors(
                        progressBarColor: Colors.red[900],
                        trackColor: Colors.red,
                        shadowColor: Colors.redAccent,
                      ),
                    ),
                    innerWidget: (double workTime) {
                      return Center(
                        child: Text(
                          '${(workTime ~/ 60).toInt().toString().padLeft(2, '0')}:${(workTime % 60).toInt().toString().padLeft(2, '0')}',
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
