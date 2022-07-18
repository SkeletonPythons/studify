// ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names
//ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:studify/models/pomodoro_models/pomodoro_history.dart';
import 'package:studify/pages/timers_page/timer_controllers/pomodoro_history_controller.dart';
import 'package:studify/utils/consts/app_colors.dart';

import '../../pages/timers_page/timer_controllers/pomodoro_controller.dart';

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
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      enabled: true,
                      onTap: () {
                        Get.snackbar('hello', 'message');
                      },
                      title: Text('Pomodoro'),
                      subtitle:
                          Text('${today.day}/${today.month}/${today.year}'),
                      trailing: Text('${today.hour}:${today.minute}'),
                    );
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
                child: ListView.builder(
                  itemCount: pomodoroController.pomodoroHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      enabled: true,
                      onTap: () {
                        Get.snackbar('hello', 'clicking this will make a new timer');
                      },
                      title: Text('${(pomodoroController.pomodoroHistory[index].timeStudied)~/60} Study ${(pomodoroController.pomodoroHistory[index].timeRested)~/60} Rest'),
                      subtitle:
                          Text('${pomodoroController.pomodoroHistory[index].cycles} Cycles'),
                      trailing: Text('${pomodoroController.pomodoroHistory[index].dateTime.month}/${pomodoroController.pomodoroHistory[index].dateTime.day}/${pomodoroController.pomodoroHistory[index].dateTime.year}'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
