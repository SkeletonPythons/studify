// ignore_for_file: prefer_const_constructors
// import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../controllers/calendar_controller.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  late Map<DateTime, List<Event>> _selectedEvents;
  final CalendarController _calendarController =
      Get.put<CalendarController>(CalendarController());
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _todayDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedEvents = {};
    _selectedDay = _todayDay;
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return _selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      maintainBottomViewPadding: false,
      bottom: false,
      child: Scaffold(
        body: Column(children: [
          SizedBox(
            height: 364,
            width: 1000,
            child: TableCalendar(
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              focusedDay: _todayDay,
              calendarFormat: _calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.twoWeeks: '2 Weeks',
                CalendarFormat.week: 'Week'
              },
              shouldFillViewport: false,
              weekendDays: const [6, 7],
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: const TextStyle(
                    color: Color(0xfff44336),
                    fontWeight: FontWeight.bold,
                    fontSize: 23),
                headerPadding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                formatButtonDecoration: BoxDecoration(
                  color: const Color(0xfff44336),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle:
                    const TextStyle(color: Color(0xffffffff)),
                formatButtonShowsNext: false,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      color: Color(0xffe53935),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  weekendStyle: TextStyle(
                      color: Color(0xff616161),
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.rectangle,
                  ),
                  selectedTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  todayDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.rectangle,
                  )),
              eventLoader: _getEventsFromDay,
              sixWeekMonthsEnforced: false,
              onDaySelected: (DateTime selectDay, DateTime todaysDay) {
                setState(() {
                  _selectedDay = selectDay;
                  _todayDay = todaysDay;
                });
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(_selectedDay, date);
              },
              onFormatChanged: (CalendarFormat format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _todayDay = focusedDay;
              },
            ),
          ),
          ..._getEventsFromDay(_selectedDay).map((Event event) => ListTile(
                title: Text(event.title),
              )),
        ]),
        floatingActionButton: SizedBox(
          height: 70,
          width: 1000,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(355.0, 0, 0, 0),
                child: FloatingActionButton(
                    backgroundColor: const Color(0xfff44336),
                    onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Add Event"),
                            content: TextFormField(
                              controller: _eventController,
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text("Ok"),
                                onPressed: () {
                                  if (_eventController.text.isEmpty) {
                                  } else {
                                    if (_selectedEvents[_selectedDay] != null) {
                                      _selectedEvents[_selectedDay]?.add(
                                        Event(title: _eventController.text),
                                      );
                                    } else {
                                      _selectedEvents[_selectedDay] = [
                                        Event(title: _eventController.text),
                                      ];
                                    }
                                  }
                                  Navigator.pop(context);
                                  _eventController.clear();
                                  setState(() {});
                                  return;
                                },
                              )
                            ],
                          ),
                        ),
                    child: const Icon(Icons.add)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
