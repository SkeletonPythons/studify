import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Pomodoro {
  DateTime dateTime;
  int workTime;
  int restTime;
  int totalCycles;
  String id;

  Pomodoro({
    required this.dateTime,
    required this.workTime,
    required this.restTime,
    required this.totalCycles,
    String? id,
  }) : id = id ?? (DateTime.now().millisecondsSinceEpoch + pepper()).toString();

  static int pepper() => Random().nextInt(50);

  Pomodoro.newLocal({
    required this.dateTime,
    required this.workTime,
    required this.restTime,
    required this.totalCycles,
    String? id,
  }) : id = id ?? (DateTime.now().millisecondsSinceEpoch + pepper()).toString();

  Pomodoro.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : id = snapshot.id,
        dateTime = snapshot.data()!['dateTime'].toDate(),
        workTime = snapshot.data()!['timeStudied'] ?? 0,
        restTime = snapshot.data()!['timeRested'] ?? 0,
        totalCycles = snapshot.data()!['cycles'] ?? 0;

  Pomodoro.fromJson(Map<String, dynamic> json)
      : dateTime = json['dateTime'].toDate() ?? DateTime.now(),
        workTime = json['timeStudied'],
        restTime = json['timeRested'],
        totalCycles = json['cycles'],
        id = json['id'];

  Map<String, dynamic> toFirestore() {
    return {
      'dateTime': dateTime,
      'timeStudied': workTime,
      'timeRested': restTime,
      'cycles': totalCycles,
    };
  }

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.millisecondsSinceEpoch,
        'timeStudied': workTime,
        'timeRested': restTime,
        'cycles': totalCycles,
        'id': id,
      };

  @override
  String toString() {
    return "\n\ndateTime:${dateTime.toIso8601String()},"
        "\n timeStudied: ${workTime.toString()},"
        " \n timeRested: ${restTime.toString()}, "
        "\n cycles: ${totalCycles.toString()}, "
        "\n,\n";
  }
}
