
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../controllers/timer_controller.dart';


class TimerHomePage extends StatefulWidget {
  const TimerHomePage({Key? key}) : super(key: key);

  @override
  TimerHomePageState createState() => TimerHomePageState();
}

class TimerHomePageState extends State<TimerHomePage>
    with SingleTickerProviderStateMixin {
  TimerController timerController = Get.put<TimerController>(TimerController());

  @override
  Widget build(BuildContext context)
  {
    var size = MediaQuery.of(context).size;
    var pomodoroIcon = 'assets/pomodoro_icon.svg';
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            decoration: const BoxDecoration(
          image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage('assets/timer_header.png'),
          ),
          ),
          ),
          Expanded(
          child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
            primary: false,
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(pomodoroIcon)
                  ],
                ),
              ),
            ],
          ),
    ),
        ],
      ),
    );
  }

  }