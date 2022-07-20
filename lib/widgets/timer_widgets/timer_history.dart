// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
//ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:studify/utils/consts/app_colors.dart';

import '../../models/pomodoro_models/history_model.dart';
import '../../pages/timers_page/timer_controllers/pomodoro_controller.dart';
import '../../services/db.dart';

class TimerHistory extends StatefulWidget {
  const TimerHistory({
    Key? key,
  }) : super(key: key);

  @override
  State<TimerHistory> createState() => _TimerHistoryState();
}

class _TimerHistoryState extends State<TimerHistory>
    with TickerProviderStateMixin {
  DateTime today = DateTime.now();
  PomodoroController pomodoroController = Get.find<PomodoroController>();

  Widget HistoryTest = StreamBuilder<QuerySnapshot<Pomodoro>>(
      stream: DB.instance.timerHistory.snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Pomodoro>> snapshot) {
        List<Pomodoro> historyList = [];
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
                  historyList.add(change.doc.data()!);
                  break;
                case DocumentChangeType.modified:
                  historyList.add(change.doc.data()!);
                  break;
                case DocumentChangeType.removed:
                  historyList.remove(change.doc.data());
                  break;
              }
            }
          }
        }
        return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              return ListTile(
                enabled: true,
                onTap: () {
                  Get.snackbar('hello', 'clicking this will make a new timer');
                },
                onLongPress: () {
                  PomodoroController.instance.pomodoroFavorites
                      .add(historyList[index]);
                  Get.snackbar('New Favorite Timer',
                      'Timer successfully added to favorites');
                },
                title: Text(
                    '${(historyList[index].timeStudied) ~/ 60} Study ${(historyList[index].timeRested) ~/ 60} Rest'),
                subtitle: Text(
                    '${historyList[index].cycles} Cycles\nLong press to add to favorites'),
                isThreeLine: true,
                trailing: Text(
                    '${historyList[index].dateTime.month}/${historyList[index].dateTime.day}/${historyList[index].dateTime.year}'),
              );
            });
      });

  Widget Favorites = StreamBuilder<QuerySnapshot<Pomodoro>>(
      stream: DB.instance.timerFavorites.snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Pomodoro>> snapshot) {
        List<Pomodoro> favoriteList = [];
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
                  favoriteList.add(change.doc.data()!);
                  break;
                case DocumentChangeType.removed:
                  favoriteList.remove(change.doc.data());
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
                  Get.snackbar('hello', 'clicking this will make a new timer');
                },
                onLongPress: () {
                  PomodoroController.instance.pomodoroFavorites.removeAt(index);
                },
                title: Text(
                    '${(favoriteList[index].timeStudied) ~/ 60} Study ${(favoriteList[index].timeRested) ~/ 60} Rest'),
                subtitle: Text(
                    '${favoriteList[index].cycles} Cycles\nLong press to add to favorites'),
                isThreeLine: true,
                trailing: Text(
                    '${favoriteList[index].dateTime.month}/${favoriteList[index].dateTime.day}/${favoriteList[index].dateTime.year}'),
              );
            });
      });

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Column(children: [
      SizedBox(
        child: TabBar(
          labelPadding: EdgeInsets.symmetric(horizontal: 30),
          labelColor: kBackground,
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          controller: tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent,
          ),
          tabs: [
            Tab(text: 'Favorites'),
            Tab(text: 'History'),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: tabController,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Obx(
                  () => ListView.builder(
                    itemCount:
                        pomodoroController.pomodoroFavorites.length.obs.value,
                    itemBuilder: (context, index) {
                      return Obx(() => ListTile(
                            enabled: true,
                            onTap: () {
                              Get.snackbar('hello', 'message');
                            },
                            onLongPress: () {
                              pomodoroController.pomodoroFavorites
                                  .removeAt(index);
                            },
                            title: Text(
                                '${(pomodoroController.pomodoroFavorites[index].timeStudied) ~/ 60} Study ${(pomodoroController.pomodoroFavorites[index].timeRested) ~/ 60} Rest'),
                            subtitle: Text(
                                '${pomodoroController.pomodoroFavorites[index].cycles} Cycles\nLong press to remove from favorites'),
                            isThreeLine: true,
                            trailing: Text(
                                '${pomodoroController.pomodoroFavorites[index].dateTime.month}/${pomodoroController.pomodoroFavorites[index].dateTime.day}/${pomodoroController.pomodoroFavorites[index].dateTime.year}'),
                          ));
                    },
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: HistoryTest,
                // child: Obx(() => ListView.builder(
                //       itemCount: pomodoroController.pomodoroHistory.length,
                //       itemBuilder: (context, index) {
                //         pomodoroController.pomodoroHistory =
                //             pomodoroController.pomodoroHistory;
                //         debugPrint(pomodoroController.pomodoroHistory.length
                //             .toString());
                //         return ListTile(
                //           enabled: true,
                //           onTap: () {
                //             Get.snackbar(
                //                 'hello', 'clicking this will make a new timer');
                //           },
                //           onLongPress: () {
                //             pomodoroController.pomodoroFavorites
                //                 .add(pomodoroController.pomodoroHistory[index]);
                //             Get.snackbar('New Favorite Timer',
                //                 'Timer successfully added to favorites');
                //           },
                //           title: Text(
                //               '${(pomodoroController.pomodoroHistory[index].timeStudied) ~/ 60} Study ${(pomodoroController.pomodoroHistory[index].timeRested) ~/ 60} Rest'),
                //           subtitle: Text(
                //               '${pomodoroController.pomodoroHistory[index].cycles} Cycles\nLong press to add to favorites'),
                //           isThreeLine: true,
                //           trailing: Text(
                //               '${pomodoroController.pomodoroHistory[index].dateTime.month}/${pomodoroController.pomodoroHistory[index].dateTime.day}/${pomodoroController.pomodoroHistory[index].dateTime.year}'),
                //         );
                //       },
                //     )),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
