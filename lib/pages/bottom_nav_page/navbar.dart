// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/auth.dart';

import '../../utils/consts/app_colors.dart';
import '../../widgets/app_bar.dart';
import '../calendar_page/calendar_page.dart';
import '../dashboard_page/dashboard_page.dart';
import '../flashcard_page/flashcard_page.dart';
import '../timers_page/timer_controllers/timer_controller.dart';

import 'navbar_controller.dart';

class NavBar extends StatelessWidget {
   NavBar({Key? key}) : super(key: key);

  TimerController timerController = Get.put<TimerController>(TimerController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(
        init: Get.put(NavBarController()),
        initState: (_) {},
        builder: (_) {
          return SafeArea(
            child: Scaffold(
              key: _.scaffoldKey,
              backgroundColor: kBackgroundDark,
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: DefaultAppBar(
                      () => _.scaffoldKey.currentState!.openDrawer())),
              drawer: AppBarDrawer(),
              body: Obx(() => TabBarView(
                    controller: _.tabController,
                    children: [
                      Dashboard(),
                      CalendarPage(),
                      TimerController.instance.activeWidget.value,
                      FlashcardPage(),
                    ],
                  )),
              bottomNavigationBar: Material(
                color: kBackgroundLight,
                child: TabBar(
                  unselectedLabelStyle: GoogleFonts.ubuntu(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kAccent,
                  ),
                  automaticIndicatorColorAdjustment: false,
                  enableFeedback: true,
                  labelStyle: GoogleFonts.ubuntu(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kAccent,
                  ),
                  controller: _.tabController,
                  tabs: _.tabs,
                  indicatorColor: kAccent,
                  labelColor: kBackgroundLight2,
                  unselectedLabelColor: kBackgroundLight,
                ),
              ),
            ),
          );
        });
  }
}

class AltAppBar extends StatelessWidget {
  const AltAppBar({
    Key? key,
    required this.onSideMenuTap,
  }) : super(key: key);

  final VoidCallback onSideMenuTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundLight2,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: kAccent,
        ),
        onPressed: onSideMenuTap,
      ),
    );
  }
}

class AppBarDrawer extends StatelessWidget {
  const AppBarDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            title: Text('Profile'),
            onTap: () => Get.snackbar(
                'Error!', 'This on tap function does nothing yet!'),
          ),
        ],
      ),
    );
  }
}
