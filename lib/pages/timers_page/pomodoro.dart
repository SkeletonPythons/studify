// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../widgets/timer_widgets/pomodoro_cycle_progress_icons.dart';
import 'timer_controllers/pomodoro_controller.dart';
import 'timer_controllers/pomodoro_history_controller.dart';
import 'timer_controllers/timer_controller.dart';
import 'timer_pomodoro_setup.dart';

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
      Get.find<PomodoroHistoryController>();

  TimerController timerController = Get.find<TimerController>();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    int maxTime = int.parse(PomodoroSetUpState.workTimeController.text) * 60;
    return Expanded(
      child: Center(
        child: Stack(children: [
          if (timerController.isRunning.value)
            GestureDetector(
              onTap: () {},
              child: Container(
                width: Get.width,
                height: Get.height,
                color: Colors.transparent,
              ),
            ),
          Positioned(
            top: 150,
            left: 47,
            child: Obx(
              () => SleekCircularSlider(
                //Obx makes widget listen for change
                initialValue: pomodoroController.workTime.value.toDouble(),
                min: 0,
                max: maxTime.toDouble(),
                appearance: CircularSliderAppearance(
                  angleRange: 360,
                  startAngle: 270,
                  size: 300,
                  customWidths: CustomSliderWidths(
                    trackWidth: 15,
                    handlerSize: 14,
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
                    child: Obx(
                      () => Text(
                        pomodoroController.FormatTime(
                            pomodoroController.workTime.value),
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
            child: Obx(
              () => CycleProgress(
                totalCycles: pomodoroController.totalCycles.value,
                currentCycle: pomodoroController.currentCycle.value,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
