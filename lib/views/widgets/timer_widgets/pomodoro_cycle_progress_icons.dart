// ignore_for_file: prefer_const_constructors
import 'dart:core';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CycleProgress extends StatelessWidget {
   CycleProgress( {
    Key? key,
    required this.totalCycles,
    required this.currentCycle,
  }) : super(key: key);
  final int totalCycles;
  final int currentCycle;
  final Icon inProgressIcon = Icon(Icons.alarm_on, size: 32, color: Colors.white,);
  final Icon doneIcon = Icon(Icons.alarm_on, size: 32, color: Colors.red,);


  @override
  Widget build(BuildContext context) {
    List<Icon> icons = [];

    for(int i = 0; i < totalCycles; i++)
      {
        if(i < currentCycle)
          {
            icons.add(doneIcon);
          }
        else{
          icons.add(inProgressIcon);
        }
      }

    return Padding(
      padding: const EdgeInsets.only(top: 480,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: icons,
      ),
    );
  }
}
