// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/views/widgets/app_bar.dart';
import 'package:studify/views/widgets/timer_widgets/number_fields.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studify/routes/routes.dart';

import '../../../controllers/timer controllers/timer_controller.dart';
import '../bottom_nav_page/bottom_nav_bar.dart';

class PomodoroSetUp extends StatefulWidget {
  const PomodoroSetUp({Key? key}) : super(key: key);

  @override
  PomodoroSetUpState createState() => PomodoroSetUpState();
}

class PomodoroSetUpState extends State<PomodoroSetUp>
    with SingleTickerProviderStateMixin {
  TimerController timerController = Get.put<TimerController>(TimerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff313131),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: DefaultAppBar(),
      ),
      body: SizedBox(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 70,
              left: 20,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Opacity(
                opacity: 0.09,
                child: SvgPicture.asset(
                  'assets/images/tomato_timer2.svg',
                ),
              ),
            ),
            Positioned(
              top: 45,
              left: 70,
              child: Text('New Pomodoro Timer',
                  style: GoogleFonts.ubuntu(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  )),
            ),
            TimerNumberField(
              prompt: 'Study time (minutes)',
              positionTop: 100,
              positionLeft: 75,
              textFieldPadding: 33,
            ),
            TimerNumberField(
              prompt: 'Rest time (minutes)',
              positionTop: 150,
              positionLeft: 75,
              textFieldPadding: 42,
            ),
            TimerNumberField(
              prompt: 'How many study cycles?',
              positionTop: 200,
              positionLeft: 75,
              textFieldPadding: 10,
            ),
            Positioned(
              top: 250,
              left: 130,
              height: 85,
              width: 85,
              child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/start_button.svg',
                  ),
                  onPressed: () {
                    timerController.isRunning = true;
                    timerController.ScreensIfPomodoroActive(); // updates navbar screens if Pomodoro timer active
                    Get.offAllNamed(Routes.NAVBAR); //Routes to navbar which will display updated screens & index
                  }),
            ),
            Positioned(
              top: 274,
              left: 205,
              height: 60,
              width: 60,
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/images/bookmark3.svg',
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
