// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:studify/controllers/timer_controllers/pomodoro_controller.dart';
import 'package:studify/controllers/timer_controllers/timer_controller.dart';
import 'package:studify/views/pages/timers_page/timer_pomodoro_setup.dart';
import '../../../controllers/timer_controllers/pomodoro_history_controller.dart';
import '../../widgets/timer_widgets/pomodoro_cycle_progress_icons.dart';

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
  double workTime = PomodoroSetUpState.workTime.toDouble();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
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
                    child: Obx(
                      () => Text(
                        '${(pomodoroController.workTime.value ~/ 60).toInt().toString().padLeft(2, '0')}:${(pomodoroController.workTime.value % 60).toInt().toString().padLeft(2, '0')}',
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
