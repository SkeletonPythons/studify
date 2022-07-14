// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
//ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:studify/models/pomodoro_models/pomodoro_history.dart';
import 'package:studify/utils/consts/app_colors.dart';

class TimerHistory extends StatefulWidget {
  const TimerHistory({
    Key? key,
  }) : super(key: key);

  //final PomodoroHistory pomodoroHistory;
  //final bool isDifferentDay;

  @override
  State<TimerHistory> createState() => _TimerHistoryState();
}

class _TimerHistoryState extends State<TimerHistory>
    with TickerProviderStateMixin {
  DateTime today = DateTime.now();

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
    ]);
  }
}
