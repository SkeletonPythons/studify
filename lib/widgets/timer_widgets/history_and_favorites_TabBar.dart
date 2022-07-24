// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
//ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:studify/pages/timers_page/timer_controllers/history_controller.dart';
import 'package:studify/utils/consts/app_colors.dart';
import 'package:studify/widgets/timer_widgets/history_item.dart';

import '../../models/pomodoro_models/history_model.dart';
import '../../pages/timers_page/timer_controllers/pomodoro_controller.dart';
import '../../services/db.dart';
import 'favorite_item.dart';

class TimerHistory extends StatefulWidget {
  const TimerHistory({
    Key? key,
  }) : super(key: key);

  @override
  State<TimerHistory> createState() => _TimerHistoryState();
}

class _TimerHistoryState extends State<TimerHistory>
    with TickerProviderStateMixin {
  DateTime today = DateTime.now();
  PomodoroController pomodoroController = Get.find<PomodoroController>();

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
      Expanded(
        child: TabBarView(
          controller: tabController,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: GetBuilder<PomodoroController>(
                  init: PomodoroController(),
                  initState: (_) {},
                  builder: (_) {
                    return FavoriteItem();
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: HistoryItem(),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
