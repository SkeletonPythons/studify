// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class TimerCard extends StatelessWidget
{
  const TimerCard({Key? key, required this.icon, required this.title}) : super(key: key);

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(icon, height: 128),
          Text(title),
        ],
      ),
    );
  }
}




