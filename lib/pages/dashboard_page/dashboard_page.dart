// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/pages/flashcard_page/flashcard_test_page/flashcard_test_page.dart';

import 'package:studify/pages/timers_page/timer_controllers/history_controller.dart';
import 'package:studify/pages/timers_page/timer_controllers/pomodoro_controller.dart';
import 'package:studify/pages/timers_page/timer_controllers/timer_controller.dart';
import 'package:studify/widgets/timer_widgets/lastFavoriteTimer.dart';

import '../../themes/apptheme.dart';
import '../../utils/consts/app_colors.dart';
import '../../../services/auth.dart';
import '../flashcard_page/flashcard_test_page/flashcard_test_controller.dart';
import '../home_page/home_controller.dart';
import '../../global_controller.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  HomeController homeController = Get.put<HomeController>(HomeController());
  PomodoroController pomodoroController =
      Get.put<PomodoroController>(PomodoroController(), permanent: true);
  TimerController timerController = Get.put<TimerController>(TimerController());
  HistoryController historyController =
      Get.put<HistoryController>(HistoryController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: kBackground,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            colors: const [
              kBackgroundLight2,
              kBackgroundLight,
              kBackground,
              kBackgroundDark,
            ],
            stops: const [0.1, 0.2, .4, 1],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: Get.width * 0.5,
              top: Get.height * 0.12,
              child: Container(
                height: Get.height * 0.02,
                width: Get.width,
                color: GC.accent.value,
              ),
            ),

            ///line from welcome circle to flashcard text
            Positioned(
              left: Get.width * 0.20,
              top: 0,
              child: Container(
                height: Get.height * 0.5,
                width: Get.width * .03,
                decoration: BoxDecoration(
                  color: GC.accent.value,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(10, 10),
                    ),
                  ],
                ),
              ),
            ),

            /// Line from flashcard text to timer quick start
            Positioned(
              left: Get.width * 0.20,
              top: Get.width * 0.8,
              child: Container(
                height: Get.height * 0.2,
                width: Get.width * .03,
                decoration: BoxDecoration(
                  color: GC.accent.value,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(10, 10),
                    ),
                  ],
                ),
              ),
            ),

            /// Welcome circle
            Positioned(
              top: -Get.width * 0.2,
              left: -Get.width * 1.1,
              child: Container(
                width: Get.width * 2.7,
                height: Get.height * .4,
                decoration: ShapeDecoration(
                  shadows: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(2, 10),
                    ),
                  ],
                  shape: CircleBorder(),
                  color: kBackgroundLight,
                ),
              ),
            ),

            /// Circle with timer quick start
            Positioned(
              bottom: -Get.width * 0.15,
              right: Get.width * .58,
              child: FavoriteTimer(),
            ),

            ///Events box
            Positioned(
              top: Get.width * 0.6,
              right: -Get.width * 0.1,
              child: Container(
                width: Get.width * .6,
                height: Get.height * .4,
                decoration: ShapeDecoration(
                  shadows: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(2, 10),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: kBackgroundLight,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.height * .01),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                        child: Text(
                          'This week...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                      Divider(thickness: 4, color: GC.accent.value),
                    ]),
              ),
            ),
            ///Welcome message
            Positioned(
              left: Get.width * 0.04,
              top: Get.height * 0.07,
              child: Text(
                Auth.instance.USER.settings!['newUser'] == true
                    ? 'Welcome to Studify,\n${Auth.instance.USER.name}!'
                    : 'Welcome back,\n${Auth.instance.USER.name}!',
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60,
                ),
              ),
            ),

            /// flashcard test circle
            Positioned(
              left: Get.width * 0.06,
              bottom: Get.height * 0.18,
              child: OutlinedButton(
                style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(Colors.black87),
                  fixedSize: MaterialStateProperty.all(
                      Size(Get.width * .32, Get.height * .32)),
                  elevation: MaterialStateProperty.all(8.0),
                  backgroundColor: MaterialStateProperty.all(kBackgroundLight),
                  foregroundColor: MaterialStateProperty.all(accentColor.value),
                  shape: MaterialStateProperty.all(
                    CircleBorder(),
                  ),
                ),
                onPressed: () {
                  Get.to(() => TP(), binding: BindingsBuilder(() {
                    Get.put(TPC());
                  }));
                },
                child: Center(
                  child: Text(
                    'Take a\nFlashcard\nTest',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: accentColor.value,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
