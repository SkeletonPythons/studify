
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({Key? key, required this.hintText, required this.controller,}) : super(key: key);
  final String? hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      textAlignVertical: TextAlignVertical.bottom,
      style: GoogleFonts.ubuntu(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 3.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3.0),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.ubuntu(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

}