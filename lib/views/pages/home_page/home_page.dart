// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:studify/views/pages/demo_page/demo.dart';
import 'package:studify/views/pages/flashcard_page/flashcard_page.dart';
import 'package:studify/views/pages/timers_page/timer_homepage.dart';
import '../../../services/auth.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    {
  HomeController homeController = Get.put<HomeController>(HomeController());

  @override
  Widget build(BuildContext context) {
    if (Auth.instance.USER.photoUrl == null ||
        Auth.instance.USER.photoUrl == '') {
      homeController.photoUrl?.value = '';
    } else {
      homeController.photoUrl?.value = Auth.instance.USER.photoUrl!;
    }
    var sideMenuIcon = 'assets/icons/menu-burger.png';
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color(0xff313131),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            backgroundColor: Colors.red[900],
            elevation: 4,
            centerTitle: true,
            title: Row(
              children: <Widget>[
                SizedBox(
                  height: 37,
                  width: 37,
                  child: IconButton(
                    icon: Image.asset(sideMenuIcon),
                    onPressed: () => {},
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 10,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 10, 8),
                  child: CircleAvatar(
                    onBackgroundImageError: (value, trace) {},
                    backgroundImage:
                        NetworkImage(homeController.photoUrl!.value),
                    radius: 25,
                    child: homeController.photoUrl!.value == ''
                        ? Text(
                            '${Auth.instance.USER.name.substring(0, 1).toUpperCase()}${Auth.instance.USER.name.split(' ')[1][0].toUpperCase()}') // <- this is the first letter of the first and last name
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  }

}
