// ignore_for_file: constant_field_initializers, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/calendar_model.dart';
import '../../../services/auth.dart';
import '../../../services/db.dart';

class CalendarController extends GetxController {
  late final Event newEvent = Event(
      title: '',
      description: '',
      startDate: null,
      endDate: null,
      location: '',
      isAllDay: false);
  List<Event> events = <Event>[].obs;

  Event createEvent({
    String title = 'New Event',
    String? description = '',
    DateTime? startDate,
    required DateTime? endDate,
    String? location = '',
    bool isAllDay = false,
  }) {
    Event event = Event(title: 'New event', endDate: endDate);
    event.startDate = DateTime.now();
    return Event(
      title: newEvent.title,
      description: '${newEvent.description}',
      startDate: startDate,
      endDate: endDate,
      location: '${newEvent.location}',
      isAllDay: isAllDay,
    );
  }

  void toggleAllDay(Event event) async {
    try {
      Map<String, dynamic> data = await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('events')
          .doc('event.id')
          .get() as Map<String, dynamic>;

      bool current = data['isAllDay'];

      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('events')
          .doc('event.id')
          .update({'isAllDay': !current});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  addNewEvenToList(List<Event> events) {
    events.add(createEvent(
        title: '',
        description: '',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 1)),
        location: '',
        isAllDay: false));
  }
}

class EventController extends GetxController {
  late final Event event;
  late RxBool editEnabled = RxBool(false);

  saveEvent(Event event) async {
    try {
      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('events')
          .doc(event.id)
          .set(event.toMap());
      SetOptions(merge: true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteEvent(Event event) async {
    try {
      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('events')
          .doc(event.id)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void toggleEdit() {
    editEnabled.value = !editEnabled.value;
  }

  void completeEditing(Event event) async {
    try {
      await DB.instance.store
          .collection('users')
          .doc(Auth.instance.USER.uid)
          .collection('events')
          .doc(event.id)
          .update({
        'title': event.title,
        'description': event.description,
        'startDate': event.startDate,
        'endDate': event.endDate,
        'location': event.location,
        'isAllDay': event.isAllDay,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  late TextEditingController _titleController =
      TextEditingController(text: event.title);
  late TextEditingController _descriptionController =
      TextEditingController(text: event.description);
  late TextEditingController _locationController =
      TextEditingController(text: event.location);

  @override
  void onInit() {
    super.onInit();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void onClose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.onClose();
  }
}
