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

  String _currentPage = 'Dashboard';
  List<String> pageKeys = ['Dashboard', 'Calendar', 'Timers', 'Flashcards'];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    'Dashboard': GlobalKey<NavigatorState>(),
    'Calendar': GlobalKey<NavigatorState>(),
    'Timers': GlobalKey<NavigatorState>(),
    'Flashcards': GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 0;

  void _selectTab(String tabItem, int index) {
    if(tabItem == _currentPage ){
      _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

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

    return WillPopScope( // necessary because otherwise going backwards will cause the app to exit
      onWillPop: () async {
        final bool? isFirstRouteInCurrentTab = await _navigatorKeys[_currentPage]?.currentState?.maybePop();

        if (isFirstRouteInCurrentTab!) {
          if (_currentPage != "Dashboard") {
            _selectTab("Dashboard", 1);

            return false;
          }
        }
        // let the system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: MaterialApp(
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
            selectedItemColor: Colors.redAccent,
            onTap: (int index) { _selectTab(pageKeys[index], index); },
            currentIndex: _selectedIndex,
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
      ),
    );
  }
}
