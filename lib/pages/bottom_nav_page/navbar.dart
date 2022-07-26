// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/routes/routes.dart';

import '../../../services/auth.dart';

import '../../global_controller.dart';
import '../../models/flashcard_model.dart';
import '../../services/db.dart';
import '../../themes/apptheme.dart';
import '../../utils/consts/app_colors.dart';
import '../../widgets/app_bar.dart';
import '../calendar_page/calendar_page.dart';
import '../dashboard_page/dashboard_page.dart';
import '../flashcard_page/note_page.dart';
import '../timers_page/timer_controllers/timer_controller.dart';

import 'navbar_controller.dart';

class NavBar extends StatelessWidget {
  NavBar({Key? key}) : super(key: key);

  final NavBarController _ = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _.scaffoldKey,
        backgroundColor: kBackgroundDark,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child:
                DefaultAppBar(() => _.scaffoldKey.currentState!.openDrawer())),
        drawer: AppBarDrawer(),
        body: Obx(() => TabBarView(
              controller: _.tabController,
              children: [
                Dashboard(),
                CalendarPage(),
                TimerController.instance.activeWidget.value,
                NotePage(),
              ],
            )),
        bottomNavigationBar: Material(
          color: kBackgroundLight,
          child: TabBar(
            unselectedLabelStyle: GoogleFonts.ubuntu(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: GC.accent.value,
            ),
            automaticIndicatorColorAdjustment: false,
            enableFeedback: true,
            labelStyle: GoogleFonts.ubuntu(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: GC.accent.value,
            ),
            controller: _.tabController,
            tabs: _.tabs,
            indicatorColor: GC.accent.value,
            labelColor: kBackgroundLight2,
            unselectedLabelColor: kBackgroundLight,
          ),
        ),
      ),
    );
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
          color: GC.accent.value,
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
            onTap: () {
              Get.toNamed(Routes.PROFILE);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text('Logout'),
            onTap: () => Auth.instance.logout(),
          ),
          AboutWidget(),
          Divider(
            thickness: 2,
            color: GC.accent.value,
          ),
          ListTile(
            leading: Icon(
              Icons.note_add_outlined,
            ),
            title: Text('Add Sample FLashcards'),
            onTap: () async {
              if (Auth.instance.USER.settings?['newUser'] == true ||
                  Auth.instance.USER.settings?['newUser'] == null) {
                Auth.instance.USER.settings!['newUser'] = false;
                try {
                  await DB.instance.user
                      .update({'settings': Auth.instance.USER.settings!});
                  DB.instance.populateWithSampleNotes();
                  Get.snackbar('Success!', 'Sample flashcards added!',
                      duration: Duration(seconds: 5));
                } catch (e) {
                  Get.snackbar('Error!', 'Something went wrong!');
                }
              } else {
                Get.snackbar('Error!', 'You already added sample flashcards!');
              }
            },
          ),
        ],
      ),
    );
  }
}

class AboutWidget extends StatelessWidget {
  const AboutWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      applicationName: 'Studify',
      applicationVersion: '0.0.0',
      applicationIcon: Icon(
        Icons.flash_on,
        color: GC.accent.value,
      ),
      icon: Icon(
        Icons.info,
        color: GC.accent.value,
      ),
      aboutBoxChildren: [
        Text(
          'Studify is a study app made by:\n\n',
          style: GoogleFonts.ubuntuMono(
            fontSize: 13,
          ),
        ),
        Text(
          'Adonis Santos\nJustin Morton\nTeresa Ortiz',
          style: GoogleFonts.architectsDaughter(fontSize: 16),
        ),
        Text(
          '\n\n2022',
          style: GoogleFonts.ubuntuMono(fontSize: 13),
        )
      ],
    );
  }
}
