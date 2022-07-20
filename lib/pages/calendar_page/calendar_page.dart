// ignore_for_file: prefer_const_constructors, unused_field, unnecessary_null_comparison
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../calendar_page/calendar_controller.dart';
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
  final EventController _eventController =
      Get.put<EventController>(EventController());
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _todayDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late Map<DateTime, DateTime> _selectedDays;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedEvents = {};
  }

  List<Event> _getEventsFromDay(DateTime date) {
    _calendarController.addNewEvenToList(_calendarController.events);
    return _calendarController.events.
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
                      onPressed: () {
                        _eventController.deleteEvent(event);
                        setState(() {
                          _selectedEvents.remove(event);
                        });
                      },
                    ),
                    onLongPress: () {},
                    contentPadding: const EdgeInsets.all(4.0),
                  )),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: const Color(0xfff44336),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => SingleChildScrollView(
              // ignore: sort_child_properties_last
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
                        controller: _titleController,
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
                        controller: _descriptionController,
                      ),
                      Divider(),
                      FormBuilderSwitch(
                        name: 'All Day',
                        title: Text('All Day'),
                        initialValue: false,
                        controlAffinity: ListTileControlAffinity.leading,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          value;
                          _calendarController.toggleAllDay(Event(
                              title: _calendarController.newEvent.title,
                              startDate: _calendarController.newEvent.startDate,
                              endDate: _calendarController.newEvent.endDate));
                        },
                      ),
                      Divider(),
                      FormBuilderDateTimePicker(
                        name: 'date_range',
                        decoration: InputDecoration(
                          labelText: 'Date Range',
                          hintText: 'Select Date Range',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        initialValue: DateTime.now(),
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
                          prefixIcon: Icon(Icons.timer),
                        ),
                        initialTime: TimeOfDay.now(),
                        inputType: InputType.time,
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
                      if (eventController.text.isEmpty) {
                      } else {
                        if (_selectedEvents[_selectedDays] != null) {
                          _selectedEvents[_selectedDays]?.add(
                            _eventController.saveEvent(
                              _calendarController.createEvent(
                                  endDate: _calendarController.newEvent.endDate,
                                  startDate:
                                      _calendarController.newEvent.startDate,
                                  title: _calendarController.newEvent.title,
                                  description:
                                      '${_calendarController.newEvent.description}',
                                  isAllDay: false),
                            ),
                            /* Event(
                                          title: _titleController.text,
                                          description: _descriptionController
                                              .text,
                                          startDate: _selectedDay,
                                          endDate: _selectedDay,
                                          location: _locationController.text,
                                          isAllDay: false), */
                          );
                        } else {
                          _selectedEvents[_selectedDay] = [
                            Event(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                startDate: _selectedDay,
                                endDate: _selectedDay,
                                location: _locationController.text,
                                isAllDay: false),
                            _eventController.saveEvent(
                              _calendarController.createEvent(
                                  endDate: _calendarController.newEvent.endDate,
                                  startDate:
                                      _calendarController.newEvent.startDate,
                                  title: _calendarController.newEvent.title,
                                  description:
                                      '${_calendarController.newEvent.description}',
                                  isAllDay: false),
                            ),
                          ];
                        }
                      }
                      Navigator.pop(context);
                      _titleController.clear();
                      _descriptionController.clear();
                      _locationController.clear();
                      setState(() {});
                      return;
                    },
                  )
                ],
              ),
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
