import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/calendar_model.dart';
import '../../../services/auth.dart';
import '../../../services/db.dart';

class CalendarController extends GetxController {
  late final Event newEvent;

  Event createEvent({
    String title = 'New Event',
    String? description = '',
    DateTime? startDate,
    DateTime? endDate,
    String? location = '',
    bool isAllDay = false,
  }) {
    return Event(
      title: newEvent.title,
      description: '${newEvent.description}',
      startDate: startDate,
      endDate: endDate,
      location: '${newEvent.location}',
      isAllDay: isAllDay,
    );
  }
}

class EventController extends GetxController {
  late final Event event;
  late RxBool editEnabled = RxBool(false);

  void setEvent(Event event) {
    this.event = event;
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
