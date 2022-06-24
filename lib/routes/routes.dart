// ignore_for_file: constant_identifier_names
// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:studify/views/pages/dashboard_page/dashboard_page.dart';
import 'package:studify/views/pages/timers_page/pomodoro.dart';
import '../../../views/pages/splash_page/splash_page.dart';
import '../../../views/pages/login_page/login_page.dart';
import '../../../views/pages/timers_page/timer_homepage.dart';
import '../../../views/pages/bottom_nav_page/bottom_nav_bar.dart';
import 'package:studify/views/pages/calendar_page/calendar_page.dart';
import '../views/pages/calendar_page/add_event.dart';
import '../views/pages/timers_page/timer_pomodoro_setup.dart';

abstract class Routes {
  static const String LOGIN = '/login';
  static const String DASH = '/dashboard';
  static const String SPLASH = '/splash';
  static const String TIMER = '/timer';
  static const String NAVBAR = '/navbar';
  static const String CALENDAR = '/calendar';
  static const String ADDEVENT = '/add_event';
  static const String POMODOROSETUP = '/pomodoro_setup';
  static const String POMODORO = '/pomodoro';
}

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.NAVBAR,
      page: () => BottomNavBar(),
    ),
    GetPage(
      name: Routes.DASH,
      page: () => Dashboard(),
    ),
    GetPage(
      name: Routes.TIMER,
      page: () => TimerHomePage(),
    ),
    GetPage(
      name: Routes.CALENDAR,
      page: () => CalendarPage(),
    ),
    GetPage(
      name: Routes.ADDEVENT,
      page: () => AddEvent(),
    ),
    GetPage(
      name: Routes.POMODOROSETUP,
      page: () => PomodoroSetUp(),
    ),
    GetPage(
      name: Routes.POMODORO,
      page: () => PomodoroTimer(),
    )
  ];
}
