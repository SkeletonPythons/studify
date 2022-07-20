import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Pomodoro {
  DateTime dateTime;
  int timeStudied;
  int timeRested;
  int cycles;
  String id;

  Pomodoro({
    required this.dateTime,
    required this.timeStudied,
    required this.timeRested,
    required this.cycles,
    String? id,
  }) : id = id ?? (DateTime.now().millisecondsSinceEpoch + pepper()).toString();

  static int pepper() => Random().nextInt(50);

  Pomodoro.newLocal({
    required this.dateTime,
    required this.timeStudied,
    required this.timeRested,
    required this.cycles,
    String? id,
  }) : id = id ?? (DateTime.now().millisecondsSinceEpoch + pepper()).toString();

  Pomodoro.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : id = snapshot.id,
        dateTime = snapshot.data()!['dateTime'] ?? DateTime.now(),
        timeStudied = snapshot.data()!['timeStudied'] ?? 0,
        timeRested = snapshot.data()!['timeRested'] ?? 0,
        cycles = snapshot.data()!['cycles'] ?? 0;

  Pomodoro.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.fromMicrosecondsSinceEpoch(json['dateTime']),
        timeStudied = json['timeStudied'],
        timeRested = json['timeRested'],
        cycles = json['cycles'],
        id = json['id'] ;

  Map<String, dynamic> toFirestore() {
    return {
      'dateTime': dateTime,
      'timeStudied': timeStudied,
      'timeRested': timeRested,
      'cycles': cycles,
    };
  }

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.millisecondsSinceEpoch,
        'timeStudied': timeStudied,
        'timeRested': timeRested,
        'cycles': cycles,
        'id': id,
      };

  @override
  String toString() {
    return "\n\ndateTime:${dateTime.toIso8601String()},"
        "\n timeStudied: ${timeStudied.toString()},"
        " \n timeRested: ${timeRested.toString()}, "
        "\n cycles: ${cycles.toString()}, "
        "\n,\n";
  }
}
