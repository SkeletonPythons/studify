// ignore_for_file: constant_identifier_names
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import '../../../routes/routes.dart';
import '../../pages/calendar_page/calendar_page.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  AddEventState createState() => AddEventState();
}

class AddEventState extends State<AddEvent>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.1,
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.red),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            Center(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              onPressed: () async {
                //save event
              },
              child: Text('Save'),
            )),
          ],
          title: const Text('Add Event', textAlign: TextAlign.center),
          titleTextStyle: const TextStyle(
            color: Colors.red,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name: "Event Title",
                  decoration: InputDecoration(
                    labelText: "Event Title",
                    hintText: "Name of the event",
                  ),
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
                  controlAffinity: ListTileControlAffinity.leading,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                Divider(),
                Center(
                  child: FormBuilderDateTimePicker(
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
                    initialDate: DateTime.now(),
                    format: DateFormat("EEEE, MMMM dd, yyyy"),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
