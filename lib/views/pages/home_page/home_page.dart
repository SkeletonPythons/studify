// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/auth.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();


}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
    var homeIcon = 'assets/icons/home-outlined64x.png';
    var calendarIcon = 'assets/icons/calendar-outlined.png';
    var timersIcon = 'assets/icons/timer.png';
    var flashcardsIcon = 'assets/icons/flashcards.png';
    var size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xff414141),
          items: [
            BottomNavigationBarItem(icon: Image.asset(homeIcon, width: 35, height: 35,), label: 'Home'),
            BottomNavigationBarItem(icon: Image.asset(calendarIcon, width: 35, height: 35,), label: 'Calendar'),
            BottomNavigationBarItem(icon: Image.asset(timersIcon, width: 35, height: 35,), label: 'Timers'),
            BottomNavigationBarItem(icon: Image.asset(flashcardsIcon, width: 35, height: 35,), label: 'Flashcards'),
          ],
          //: MediaQuery.of(context).size.height * .1,
          //width: MediaQuery.of(context).size.width,
          //child: TabBar(
          //tabs: <Widget>[
          //const Icon(Icons.home),
          //const Icon(Icons.flash_on),
          //Container(),
          //Container(),
          //],
          //controller: homeController.tabController,
        ),
      ),
    );
  }
}
