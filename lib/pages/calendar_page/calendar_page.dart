// ignore_for_file: prefer_const_constructors, unused_field
// import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../routes/routes.dart';
import '../../pages/calendar_page/calendar_controller.dart';
import '../../models/calendar_model.dart';

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
      child: Scaffold(
        body: SizedBox(
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: size.height * 0.61,
                width: size.width,
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
                    headerPadding:
                        const EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                    //subtitle: Text(event.description, maxLines: 2),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                    onLongPress: () {},
                    contentPadding: const EdgeInsets.all(4.0),
                  )),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
            backgroundColor: const Color(0xfff44336),
            onPressed: () {
              Navigator.pushNamed(context, Routes.ADDEVENT);
            },

            /* onPressed: () => showDialog(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        child: AlertDialog(
                          title: const Text("Add Event"),
                          content: FormBuilder(
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                  name: "Event Title",
                                  decoration: InputDecoration(
                                    labelText: "Event Title",
                                    hintText: "Name of the event",
                                  ),
                                  controller: _eventController,
                                ),
                                FormBuilderTextField(
                                  name: "Description",
                                  maxLines: 5,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    labelText: "Description",
                                    hintText: "Description of the event",
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.short_text),
                                  ),
                                ),
                                Divider(),
                                FormBuilderSwitch(
                                  name: 'All Day',
                                  title: Text('All Day'),
                                  initialValue: false,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                                Divider(),
                                FormBuilderDateTimePicker(
                                  name: "Date",
                                  decoration: InputDecoration(
                                    labelText: "Date",
                                    floatingLabelStyle: TextStyle(
                                        color: const Color(0xfff44336),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  initialValue: DateTime.now(),
                                  initialTime: TimeOfDay.now(),
                                  inputType: InputType.date,
                                  initialDate: _selectedDay,
                                  format: DateFormat("EEEE, MMMM dd, yyyy"),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: const Text("Save"),
                              onPressed: () {
                                if (_eventController.text.isEmpty) {
                                } else {
                                  if (_selectedEvents[_selectedDay] != null) {
                                    _selectedEvents[_selectedDay]?.add(
                                      Event(
                                          title: _eventController.text,
                                          description: _eventController.text,
                                          startDate: _selectedDay,
                                          endDate: _selectedDay,
                                          location: _eventController.text,
                                          isAllDay: false),
                                    );
                                  } else {
                                    _selectedEvents[_selectedDay] = [
                                      Event(
                                          title: _eventController.text,
                                          description: _eventController.text,
                                          startDate: _selectedDay,
                                          endDate: _selectedDay,
                                          location: _eventController.text,
                                          isAllDay: false),
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
                        ),*/
            child: const Icon(Icons.add)),
      ),
    );
  }
}
