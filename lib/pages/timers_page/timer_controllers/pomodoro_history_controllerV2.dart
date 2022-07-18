import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../models/pomodoro_models/pomodoro_history.dart';
import '../../../services/db.dart';

class HistoryControllerV2 extends GetxController {
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

  void addTimerToDatabase(PomodoroHistory historyItem) async {
    print('Adding timer to database');
    await DB.instance.timers.doc(historyItem.id).set(historyItem).catchError((e) {
      print('\n\nerror adding timer: $e\n\n');
    });
  }



}