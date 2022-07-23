import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/pages/bottom_nav_page/navbar_controller.dart';
import 'package:studify/pages/timers_page/timer_controllers/timer_controller.dart';

import '../../models/pomodoro_models/history_model.dart';
import '../../pages/timers_page/pomodoro.dart';
import '../../pages/timers_page/timer_controllers/history_controller.dart';
import '../../pages/timers_page/timer_controllers/pomodoro_controller.dart';
import '../../pages/timers_page/timer_pomodoro_setup.dart';
import '../../services/db.dart';
import '../../themes/apptheme.dart';
import '../../utils/consts/app_colors.dart';

class FavoriteTimer extends StatefulWidget {
  const FavoriteTimer({Key? key}) : super(key: key);

  @override
  FavoriteTimerState createState() => FavoriteTimerState();
}

class FavoriteTimerState extends State<FavoriteTimer>
    with TickerProviderStateMixin {
  PomodoroController pomodoroController = Get.find<PomodoroController>();
  HistoryController historyController = Get.find<HistoryController>();
  TimerController timerController = Get.find<TimerController>();
  List<Pomodoro> favoriteList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Pomodoro>>(
        stream: DB.instance.timerFavorites.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Pomodoro>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            debugPrint('history data: ${snapshot.data}');
            if (snapshot.data!.docChanges.isNotEmpty) {
              var changes = snapshot.data!.docChanges;

              for (var change in changes) {
                DocumentChangeType type = change.type;

                switch (type) {
                  case DocumentChangeType.added:
                    favoriteList.add(change.doc.data()!);
                    break;
                  case DocumentChangeType.modified:
                    int ind = favoriteList.indexWhere(
                            (element) => element.id == change.doc.data()!.id);
                    Pomodoro changed = change.doc.data()!;
                    favoriteList.removeAt(ind);
                    favoriteList.insert(ind, changed);
                    break;
                  case DocumentChangeType.removed:
                    favoriteList.removeWhere(
                            (element) => element.id == change.doc.data()!.id);
                    break;
                }
              }
            }
          }
          return OutlinedButton(
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.black87),
              fixedSize: MaterialStateProperty.all(
                  Size(Get.width * .40, Get.height * .40)),
              elevation: MaterialStateProperty.all(8.0),
              backgroundColor: MaterialStateProperty.all(kBackgroundLight),
              foregroundColor: MaterialStateProperty.all(accentColor.value),
              shape: MaterialStateProperty.all(
                CircleBorder(),
              ),
            ),
            onPressed: () {
              pomodoroController.workTime.value =
              (favoriteList[favoriteList.length -1].workTime * 60);
              pomodoroController.restTime.value =
              (favoriteList[favoriteList.length -1].restTime * 60);
              pomodoroController.totalCycles.value =
                  favoriteList[favoriteList.length -1].totalCycles;

              PomodoroSetUpState.workTimeController.text =
                  favoriteList[favoriteList.length -1].workTime.toString();
              PomodoroSetUpState.restTimeController.text =
                  favoriteList[favoriteList.length -1].restTime.toString();
              PomodoroSetUpState.cycleController.text =
                  favoriteList[favoriteList.length -1].totalCycles.toString();

              timerController.isRunning.value = true;
              pomodoroController.StartPomodoro();

              ///set the active page to the timer
              timerController.setActiveWidget(PomodoroTimer());

              /// This is temporary until i can figure out the routing issue
              ///
              Get.snackbar('Timer started', 'Head to the timer tab to see it!',
                  backgroundColor: kBackgroundLight,
                  colorText: kTextColor,
                  snackPosition: SnackPosition.TOP,
                  duration: Duration(seconds: 2));
              /// updates navbar screens if Pomodoro timer active
              ///Routes to navbar which will display updated screens & index
            },
            child: Text(
              'Start Your Latest Favorite Study Timer',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
