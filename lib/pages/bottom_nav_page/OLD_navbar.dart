// ignore_for_file: prefer_const_constructors, file_names
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Use relative imports on our files to avoid collisions with other libraries.
// They will begin with "../" or "./" instead of "package:".
// "./" means current directory. "../" means parent directory.

import '../../../services/auth.dart';
import '../../routes/routes.dart';
import '../../widgets/app_bar.dart';
import '../calendar_page/calendar_page.dart';
import '../dashboard_page/dashboard_page.dart';
import '../flashcard_page/flashcard_page.dart';
import '../timers_page/timer_controllers/timer_controller.dart';
import '../timers_page/timer_homepage.dart';
import '../../pages/bottom_nav_page/home_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  // ** Consider using a TabBar an dTabBarView instead of a BottomNavBar. It has an animation built in for transitioning between pages.

  static List<Widget> screens = [
    Dashboard(),
    CalendarPage(),
    TimerHomePage(),
    FlashcardPage(),
  ];

  static int selectedIndex = 0;

  RxBool alternateReality = false.obs;
  HomeController homeController = Get.put<HomeController>(HomeController());
  TimerController timerController = Get.put<TimerController>(TimerController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /*made screen and selectedIndex static in order to access them from other
  controllers/classes in case page order needs to change*/

  @override
  Widget build(BuildContext context) {
    var homeIcon = 'assets/icons/home-outlined64x.png';
    var calendarIcon = 'assets/icons/calendar-outlined.png';
    var timersIcon = 'assets/icons/timer.png';
    var flashcardsIcon = 'assets/icons/flashcards.png';

    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child:
                DefaultAppBar(() => _scaffoldKey.currentState!.openDrawer())),
        body: !alternateReality.value
            ? IndexedStack(
                index: selectedIndex,
                children: screens,
              )
            : Container(),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                ),
                child: CircleAvatar(
                  maxRadius: 50,
                  onBackgroundImageError: (value, trace) {},
                  backgroundImage: Auth.instance.USER.photoUrl == ''
                      ? AssetImage('assets/images/user.png')
                      : NetworkImage(Auth.instance.USER.photoUrl!, scale: .25)
                          as ImageProvider,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.developer_mode_sharp,
                ),
                title: Text('Alternate Reality'),
                onTap: () => Get.offAllNamed(Routes.ALT_HOME),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xff414141),
          currentIndex: selectedIndex,
          selectedItemColor: Colors.redAccent,
          onTap: (index) => setState(() => selectedIndex = index),
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  homeIcon,
                  width: 35,
                  height: 35,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  calendarIcon,
                  width: 35,
                  height: 35,
                ),
                label: 'Calendar'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  timersIcon,
                  width: 35,
                  height: 35,
                ),
                label: 'Timers'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  flashcardsIcon,
                  width: 35,
                  height: 35,
                ),
                label: 'Flashcards'),
          ],
        ));
  }
}
