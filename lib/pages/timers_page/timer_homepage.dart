// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:studify/routes/routes.dart';

import '../../widgets/timer_widgets/timer_cards.dart';
import 'timer_controllers/timer_controller.dart';

class TimerHomePage extends StatefulWidget {
  const TimerHomePage({Key? key}) : super(key: key);

  @override
  TimerHomePageState createState() => TimerHomePageState();
}

class TimerHomePageState extends State<TimerHomePage>
    with SingleTickerProviderStateMixin {
  TimerController timerController = Get.put<TimerController>(TimerController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 81.0, right: 20.0),
          child: SizedBox(
            height: size.height * 0.5,
            width: size.width,
            child: Text(
              'Study Timers',
              style: GoogleFonts.ubuntu(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          primary: false,
          children: <Widget>[
            TimerCard(
                icon: timerController.pomodoroIcon,
                cardTitle: 'Pomodoro Timer',
                routeForOnPressed: Routes.POMODOROSETUP),
            TimerCard(
                icon: timerController.stopwatchIcon,
                cardTitle: 'Stopwatch Timer',
                routeForOnPressed: Routes.DASH),
            TimerCard(
                icon: timerController.countdownIcon,
                cardTitle: 'Countdown Timer',
                routeForOnPressed: Routes.DASH),
            TimerCard(
                icon: timerController.timerStats,
                cardTitle: 'Timer Statistics',
                routeForOnPressed: Routes.DASH),
          ],
        ),
      ],
    );
  }
}
