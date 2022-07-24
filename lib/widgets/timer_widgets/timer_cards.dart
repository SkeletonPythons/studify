// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerCard extends StatelessWidget {
  const TimerCard(
      {Key? key,
      required this.icon,
      required this.cardTitle,
      required this.routeForOnPressed})
      : super(key: key);

  final String icon;
  final String cardTitle;
  final String routeForOnPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () => Get.toNamed(routeForOnPressed),
            icon: SvgPicture.asset(icon),
            iconSize: 115,
          ),
          Text(
            cardTitle,
            style: GoogleFonts.ubuntu(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
