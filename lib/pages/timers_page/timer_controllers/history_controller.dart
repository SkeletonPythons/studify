import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import '../../../models/pomodoro_models/history_model.dart';
import '../../../services/auth.dart';
import '../../../services/db.dart';

class HistoryController extends GetxController {
  List<String>? list = [];
  List<Pomodoro>? pomodoroHistory = [];

  Pomodoro SaveNewHistoryItem(int workTime, int restTime, int totalCycles) {
    Pomodoro newHistoryItem = Pomodoro(
        dateTime: DateTime.now(),
        workTime: workTime,
        restTime: restTime,
        totalCycles: totalCycles);
    return newHistoryItem;
  }

  Future addTimerToDatabase(Pomodoro historyItem, CollectionReference<Pomodoro> collectionRef) async {
    await collectionRef
        .doc(historyItem.id)
        .set(historyItem, SetOptions(merge: true));
    print('timer added to database');
  }
}