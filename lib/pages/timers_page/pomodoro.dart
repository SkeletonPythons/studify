// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    int maxTime = int.parse(PomodoroSetUpState.workTimeController.text) * 60;
    Rx<PomodoroStatus> currentPomodoroStatus = PomodoroStatus.running.obs;
    return Center(
      child: Stack(alignment: AlignmentDirectional.topCenter,children: [
        if (timerController.isRunning.value)
          GestureDetector(
            onTap: () {},
            child: Container(
              width: Get.width,
              height: Get.height,
              color: Colors.transparent,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Obx(
          () => Text('${pomodoroController.displayStatus[currentPomodoroStatus.value]}',
                style: GoogleFonts.roboto(
                  fontSize: Get.height * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
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
                counterClockwise: true,
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
                  trackColor: pomodoroController.statusColors[currentPomodoroStatus.value],
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
        Padding(
          padding: const EdgeInsets.only(top: 500, left: 60),
          child: Row(
            children: [
              SizedBox(
                height: 120,
                child: IconButton(
                  iconSize: 60,
                  icon: SvgPicture.asset('assets/icons/play_pause.svg'),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: 100,
                child: IconButton(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 120),
                  iconSize: 60,
                  icon: SvgPicture.asset('assets/icons/stop_button2.svg'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

      ]),
    );
  }
}
