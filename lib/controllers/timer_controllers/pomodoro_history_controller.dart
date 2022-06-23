// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../models/pomodoro_models/pomodoro_history.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PomodoroHistoryController extends GetxController {
  List<String>? list = [];
  List<PomodoroHistory>? pomodoroHistory = [];
  static SharedPreferences? sharedPreferences;

  static Future init() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  read(String key) {
    try {
      pomodoroHistory!.clear();
      list!.clear();
      list!.addAll(sharedPreferences!.getStringList(key)!);
      for (var item in list!) {
        pomodoroHistory!.add(PomodoroHistory.fromJson(json.decode(item)));
      }
    } catch (_){} return pomodoroHistory;
  }

  save(String key, List<PomodoroHistory> pomodoroHistory) async {
    list!.clear();
    for (var item in pomodoroHistory) {
      list!.add(json.encode(item.toJson()));
    }
    sharedPreferences!.setStringList(key, list!);
  }
}