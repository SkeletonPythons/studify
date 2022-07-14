// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class TimerNumberField extends StatelessWidget {
  const TimerNumberField(
      {Key? key,
      required this.prompt,
      required this.positionTop,
      required this.positionLeft,
      required this.textFieldPadding,
      required this.textController,
      required this.value})
      : super(key: key);

  final String prompt;
  final double positionTop;
  final double positionLeft;
  final double textFieldPadding;
  final TextEditingController textController;
  final RxInt value;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: positionTop,
      left: positionLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(prompt,
              style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          Padding(
            padding: EdgeInsets.only(left: textFieldPadding),
            child: SizedBox(
              height: 35,
              width: 55,
              child: TextField(
                controller: textController,
                onChanged: (value) => this.value.value = int.parse(value),
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
