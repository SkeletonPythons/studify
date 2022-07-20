
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/pomodoro_models/history_model.dart';
import '../../pages/timers_page/timer_controllers/history_controller.dart';
import '../../pages/timers_page/timer_controllers/pomodoro_controller.dart';
import '../../services/db.dart';

class FavoriteItem extends StatefulWidget {
  const FavoriteItem({Key? key}) : super(key: key);

  @override
  FavoriteItemState createState() => FavoriteItemState();
}

class FavoriteItemState extends State<FavoriteItem> with TickerProviderStateMixin {
  PomodoroController pomodoroController = Get.find<PomodoroController>();
  HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Pomodoro>>(
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
                    DB.instance.timerFavorites.doc(favoriteList[index].id).delete();
                    Get.snackbar('Timer Removed', 'timer will no longer show up in your favorites');
                  },
                  title: Text(
                      '${(favoriteList[index].timeStudied)} Study ${(favoriteList[index].timeRested)} Rest'),
                  subtitle: Text(
                      '${favoriteList[index].cycles} Cycles\nLong press to remove from favorites'),
                  isThreeLine: true,
                  trailing: Text(
                      '${favoriteList[index].dateTime.month}/${favoriteList[index].dateTime.day}/${favoriteList[index].dateTime.year}'),
                );
              });
        });
  }
}