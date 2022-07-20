// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studify/pages/timers_page/timer_controllers/history_controller.dart';
import 'package:studify/widgets/timer_widgets/history_and_favorites_TabBar.dart';
import '../../models/pomodoro_models/history_model.dart';
import '../../services/db.dart';
import '../../utils/consts/app_colors.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/timer_widgets/number_fields.dart';
import 'pomodoro.dart';
import 'timer_controllers/pomodoro_controller.dart';
import 'timer_controllers/timer_controller.dart';

class PomodoroSetUp extends StatefulWidget {
  const PomodoroSetUp({Key? key}) : super(key: key);

  @override
  PomodoroSetUpState createState() => PomodoroSetUpState();
}

class PomodoroSetUpState extends State<PomodoroSetUp>
    with SingleTickerProviderStateMixin {
  static int workTime = 0;

  /// text editing controllers for the number fields on the set up page
  static TextEditingController workTimeController = TextEditingController();
  static TextEditingController restTimeController = TextEditingController();
  static TextEditingController cycleController = TextEditingController();
  int numOfCycles = 1;

  /// text editing validators for the number fields on the set up page
  bool areTextFieldsEmpty() {
    if (workTimeController.text.isEmpty ||
        restTimeController.text.isEmpty ||
        cycleController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool valueIsNotNumber(){
    if(int.tryParse(workTimeController.text) == null ||
        int.tryParse(restTimeController.text) == null ||
        int.tryParse(cycleController.text) == null) {
      return true;
    } else{
        return false;
      }
  }

  bool numberIsLessThanZero()
  {
    if(int.tryParse(workTimeController.text)! <= 0 ||
        int.tryParse(restTimeController.text)! <= 0 ||
        int.tryParse(cycleController.text)! <= 0) {
      return true;
    } else{
        return false;
      }
  }

  void callErrorSnackbar(String errorMessage) {
    Get.snackbar('Error', errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ));
  }

  /// controllers
  PomodoroController pomodoroController =
      Get.put<PomodoroController>(PomodoroController(), permanent: true);

  HistoryController pomodoroHistoryController =
      Get.put<HistoryController>(HistoryController(), permanent: true);

  TimerController timerController = Get.find<TimerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: DefaultAppBar(() {}),
      ),
      body: Stack(
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
            textController: workTimeController,
            timerValue: pomodoroController.workTime,
          ),
          TimerNumberField(
            prompt: 'Rest time (minutes)',
            positionTop: 150,
            positionLeft: 75,
            textFieldPadding: 42,
            textController: restTimeController,
            timerValue: pomodoroController.restTime,
          ),
          TimerNumberField(
            prompt: 'How many study cycles?',
            positionTop: 200,
            positionLeft: 75,
            textFieldPadding: 10,
            textController: cycleController,
            timerValue: pomodoroController.totalCycles,
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
                  if(areTextFieldsEmpty()) {
                    callErrorSnackbar('Please fill in all fields');
                  }
                  else if(valueIsNotNumber()) {
                    callErrorSnackbar('Please enter only valid non zero numbers');
                  }
                  else if(numberIsLessThanZero()) {
                    callErrorSnackbar('Please enter only non zero numbers');
                    }
                  else {
                    pomodoroController.workTime.value =
                        int.parse(workTimeController.text) * 60;
                    pomodoroController.restTime.value =
                        int.parse(restTimeController.text) * 60;
                    pomodoroController.totalCycles.value =
                        int.parse(cycleController.text);
                    timerController.isRunning.value = true;
                    pomodoroController.StartPomodoro();

                    /// add the new pomodoro to the database
                    final newTimer = Pomodoro(
                        dateTime: DateTime.now(),
                        workTime: int.parse(workTimeController.text),
                        restTime: int.parse(restTimeController.text),
                        totalCycles: int.parse(cycleController.text));
                    pomodoroHistoryController.addTimerToDatabase(
                        newTimer, DB.instance.timerHistory);

                    ///set the active page to the timer
                    timerController.setActiveWidget(PomodoroTimer());

                    /// updates navbar screens if Pomodoro timer active
                    ///Routes to navbar which will display updated screens & index
                    Get.back();
                  }
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
              onPressed: () {
                final newTimer = Pomodoro(
                    dateTime: DateTime.now(),
                    workTime: int.parse(workTimeController.text),
                    restTime: int.parse(restTimeController.text),
                    totalCycles: int.parse(cycleController.text));
                pomodoroHistoryController.addTimerToDatabase(newTimer, DB.instance.timerFavorites);
                Get.snackbar('Timer Added', 'your timer has been added to favorites!');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 340, left: 15, right: 15),
            child: TimerHistory(),
          ),
        ],
      ),
    );
  }
}
