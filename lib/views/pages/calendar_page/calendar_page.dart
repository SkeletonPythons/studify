import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/views/widgets/app_bar.dart';
import '../../../controllers/home_controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../services/auth.dart';
//import 'package:googleapis/calendar/v3.dart';

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
    return Container(
      // backgroundColor: const Color(0xff313131),
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(80.0),
      //   child: DefaultAppBar(),
      // ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 150),
        child: SfCalendar(
          backgroundColor: const Color(0xff313131),
          todayHighlightColor: Colors.blueGrey[800],
          todayTextStyle: TextStyle(
              color: Colors.red[900],
              fontSize: 14,
              fontWeight: FontWeight.bold),
          cellBorderColor: Colors.red[700],
          view: CalendarView.month,
          firstDayOfWeek: 1,
          headerHeight: 50,
          viewHeaderHeight: -1,
          viewHeaderStyle: const ViewHeaderStyle(
            backgroundColor: Colors.red,
            dayTextStyle: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            dateTextStyle: TextStyle(color: Colors.black, fontSize: 14),
          ),
          headerStyle: const CalendarHeaderStyle(
              textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          monthViewSettings: MonthViewSettings(
            numberOfWeeksInView: 6,
            monthCellStyle: MonthCellStyle(
              todayBackgroundColor: Colors.blueGrey[800],
              textStyle: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              trailingDatesTextStyle: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 14,
              ),
              leadingDatesTextStyle: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 14,
              ),
            ),
          ),
          // initialDisplayDate: DateTime(2022, 06, 14, 17, 09),
          // initialSelectedDate: DateTime(2022, 06, 14, 17, 09),
          // dataSource: AddDataSource(getAppointments()),
        ),
      ),
    );
  }
}
