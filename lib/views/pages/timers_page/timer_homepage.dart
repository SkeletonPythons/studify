// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/views/widgets/timer_widgets/timer_cards.dart';
import '../../../controllers/timer_controller.dart';
import '../../../controllers/home_controller.dart';

class TimerHomePage extends StatefulWidget {
  const TimerHomePage({Key? key}) : super(key: key);

  @override
  TimerHomePageState createState() => TimerHomePageState();
}

class TimerHomePageState extends State<TimerHomePage>
    with SingleTickerProviderStateMixin {
  TimerController timerController = Get.put<TimerController>(TimerController());
  HomeController homeController = Get.put<HomeController>(HomeController());
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            width: Get.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                scale: 4,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/images/timer_header.png'),
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            primary: false,
            children: <Widget>[
              TimerCard(
                  icon: timerController.pomodoroIcon,
                  title: 'New Pomodoro Timer'),
              TimerCard(
                  icon: timerController.stopwatchIcon,
                  title: 'New Stopwatch Timer'),
              TimerCard(
                  icon: timerController.countdownIcon,
                  title: 'New Countdown Timer'),
              TimerCard(
                  icon: timerController.presetTimers, title: 'Preset Timers'),
              TimerCard(
                  icon: timerController.savedTimers, title: 'Saved Timers'),
              TimerCard(
                  icon: timerController.timerStats, title: 'Timer Statistics'),
            ],
          ),
        ],
      ),
    );
  }
}
