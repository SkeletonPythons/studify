import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import '../../../models/pomodoro_models/history_model.dart';
import '../../../services/auth.dart';
import '../../../services/db.dart';

class HistoryController extends GetxController {
  List<String>? list = [];
  List<PomodoroHistory>? pomodoroHistory = [];

  PomodoroHistory SaveNewHistoryItem(int workTime, int restTime, int totalCycles) {
    PomodoroHistory newHistoryItem = PomodoroHistory(
        dateTime: DateTime.now(),
        timeStudied: workTime,
        timeRested: restTime,
        cycles: totalCycles);
    return newHistoryItem;
  }

  Future addTimerToDatabase(PomodoroHistory historyItem) async {
    await DB.instance.timers.doc(historyItem.id).set(historyItem.toFirestore(), SetOptions(merge: true));
    print('timer added to database');
  }



}