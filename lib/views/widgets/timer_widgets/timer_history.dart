import 'package:flutter/material.dart';
import 'package:studify/models/pomodoro_models/pomodoro_history.dart';

class TimerHistory extends StatefulWidget {
  const TimerHistory(
      {Key? key, required this.pomodoroHistory, required this.isDifferentDay})
      : super(key: key);

  final PomodoroHistory pomodoroHistory;
  final bool isDifferentDay;

  @override
  State<TimerHistory> createState() => _TimerHistoryState();
}

class _TimerHistoryState extends State<TimerHistory> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
    );
  }
}
