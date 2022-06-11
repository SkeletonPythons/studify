// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // ** Try not to use `var` when typing variables.
    // ** It could lead to unexpected results.
    // ** Also this is something that would be put in the controller
    // ** as it is part of the logic and is not a part of the UI.
    // ** The goal of the controller is to not to have to search for things if
    // ** we wanted to change them. That way all we would have to do is change the
    // ** logic and the UI would be updated automatically.
    final Size size = MediaQuery.of(context).size;
    const String pomodoroIcon = 'assets/images/pomodoro_icon.svg';
    const String stopwatchIcon = 'assets/images/stopwatch_icon.svg';
    const String countdownIcon = 'assets/images/countdown_icon.svg';
    const String presetTimers = 'assets/images/preset_timers.svg';
    const String savedTimers = 'assets/images/saved_timers.svg';
    const String timerStats = 'assets/images/timer_stats.svg';

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
              // ** This is an example of something that you'd want to create in the widgets
              // ** folder and call it for each of the grid cards.
              // ** an example would be:
              /** class TimerCard extends StatelessWidget {
               * const TimerCard({Key? key, this.icon, this.title}) : super(key: key);
               *
               * final String icon;
               * final String title;
               *
               * @override
               * Widget build(BuildContext context) {
               * return Card(
               * shape: RoundedRectangleBorder(
               *   borderRadius: BorderRadius.circular(8),
               * ),
               * elevation: 10,
               * child: Column(
               *   mainAxisAlignment: MainAxisAlignment.center,
               *   children: <Widget>[
               *     SvgPicture.asset(icon, height: 128),
               *     Text(title),
               *   ],
               * ),
               * ),
              */
              // ** And then here you would call the TimerCard widget and pass in the
              // ** icon and title.
              /**
               * TimerCard(
               *  icon: pomodoroIcon,
               * title: 'Pomodoro'
               * ),
               */
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(pomodoroIcon, height: 128),
                    Text('New Pomodoro Timer'),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(stopwatchIcon, height: 128),
                    Text('New Stopwatch Timer'),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(countdownIcon, height: 128),
                    Text('New Countdown Timer'),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(presetTimers, height: 128),
                    Text('Preset Timers'),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(savedTimers, height: 128),
                    Text('Saved Timers'),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(timerStats, height: 128),
                    Text('Timer Statistics'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
