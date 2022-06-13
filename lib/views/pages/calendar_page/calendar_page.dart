import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/controllers/calendar_controller.dart';
import 'package:studify/views/widgets/app_bar.dart';
import '../../../controllers/timer_controller.dart';
import '../../../controllers/home_controller.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  CalendarController calendarController =
      Get.put<CalendarController>(CalendarController());
  HomeController homeController = Get.put<HomeController>(HomeController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xff313131),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: DefaultAppBar(),
      ),
    );
  }
}
