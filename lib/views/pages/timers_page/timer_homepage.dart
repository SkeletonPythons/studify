// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    var size = MediaQuery.of(context).size;
    var pomodoroIcon = 'assets/pomodoro_icon.svg';
    var stopwatchIcon = 'assets/stopwatch_icon.svg';
    var countdownIcon = 'assets/countdown_icon.svg';
    var presetTimers = 'assets/preset_timers.svg';
    var savedTimers = 'assets/saved_timers.svg';
    var timerStats = 'assets/timer_stats.svg';

    return Scaffold(
      bottomNavigationBar: Container(
        color: Color(0xff414141),
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width,
        child: TabBar(
          tabs: <Widget>[
            Container(child: Icon(Icons.home)),
            Container(child: Icon(Icons.flash_on)),
            Container(),
            Container()
          ],
          controller: homeController.tabController,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                scale: 4,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/timer_header.png'),
              ),
            ),
          ),
          GridView.count(
            padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            primary: false,
            children: <Widget>[
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
