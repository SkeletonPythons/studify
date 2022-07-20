
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../models/pomodoro_models/history_model.dart';
import '../../pages/timers_page/timer_controllers/history_controller.dart';
import '../../pages/timers_page/timer_controllers/pomodoro_controller.dart';
import '../../services/db.dart';

class HistoryItem extends StatefulWidget {
  const HistoryItem({
    Key? key,
  }) : super(key: key);

  @override
  State<HistoryItem> createState() => HistoryItemState();
}

  class HistoryItemState extends State<HistoryItem> with TickerProviderStateMixin {
    DateTime today = DateTime.now();
    PomodoroController pomodoroController = Get.find<PomodoroController>();
    HistoryController historyController = Get.find<HistoryController>();

    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot<Pomodoro>>(
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
                      HistoryController historyController = Get.find<HistoryController>();
                      historyController.addTimerToDatabase(historyList[index], DB.instance.timerFavorites);
                      Get.snackbar('New Favorite Timer',
                          'Timer successfully added to favorites');
                    },
                    title: Text(
                        '${(historyList[index].timeStudied)} Study ${(historyList[index].timeRested)} Rest'),
                    subtitle: Text(
                        '${historyList[index].cycles} Cycles\nLong press to add to favorites'),
                    isThreeLine: true,
                    trailing: Text(
                        '${historyList[index].dateTime.month}/${historyList[index].dateTime.day}/${historyList[index].dateTime.year}'),
                  );
                });
          });
    }


  }
