import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/shared.dart';
import 'package:studify/pages/timers_page/timer_controllers/timer_controller.dart';
import 'package:studify/pages/timers_page/timer_pomodoro_setup.dart';

import '../../models/pomodoro_models/history_model.dart';
import '../../pages/timers_page/pomodoro.dart';
import '../../pages/timers_page/timer_controllers/history_controller.dart';
import '../../pages/timers_page/timer_controllers/pomodoro_controller.dart';
import '../../services/db.dart';

class FavoriteItem extends StatefulWidget {
  const FavoriteItem({Key? key}) : super(key: key);

  @override
  FavoriteItemState createState() => FavoriteItemState();
}

class FavoriteItemState extends State<FavoriteItem>
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
          return ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  enabled: true,
                  onTap: () {
                    ///Start a pomodoro from the favorites list
                    pomodoroController.workTime.value =
                        (favoriteList[index].workTime * 60);
                    pomodoroController.restTime.value =
                        (favoriteList[index].restTime * 60);
                    pomodoroController.totalCycles.value =
                        favoriteList[index].totalCycles;

                    PomodoroSetUpState.workTimeController.text =
                        favoriteList[index].workTime.toString();
                    PomodoroSetUpState.restTimeController.text =
                        favoriteList[index].restTime.toString();
                    PomodoroSetUpState.cycleController.text =
                        favoriteList[index].totalCycles.toString();

                    timerController.isRunning.value = true;
                    pomodoroController.StartPomodoro();

                    /// add the new pomodoro to the database
                    final newTimer = Pomodoro(
                        dateTime: DateTime.now(),
                        workTime: favoriteList[index].workTime,
                        restTime: favoriteList[index].restTime,
                        totalCycles: favoriteList[index].totalCycles);

                    historyController.addTimerToDatabase(
                        newTimer, DB.instance.timerHistory);

                    ///set the active page to the timer
                    timerController.setActiveWidget(const PomodoroTimer());

                    /// updates navbar screens if Pomodoro timer active
                    ///Routes to navbar which will display updated screens & index
                    Get.back();
                  },
                  onLongPress: () {
                    DB.instance.timerFavorites
                        .doc(favoriteList[index].id)
                        .delete();
                    Get.snackbar('Timer Removed',
                        'timer will no longer show up in your favorites');
                    setState(() {});
                  },
                  title: Text(
                      '${(favoriteList[index].workTime)} Study ${(favoriteList[index].restTime)} Rest'),
                  subtitle: Text(
                      '${favoriteList[index].totalCycles} Cycles\nLong press to remove from favorites'),
                  isThreeLine: true,
                  trailing: Text(
                      '${favoriteList[index].dateTime.month}/${favoriteList[index].dateTime.day}/${favoriteList[index].dateTime.year}'),
                );
              });
        });
  }
}
