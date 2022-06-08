// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:studify/views/pages/home_page/home_page.dart';
import '../../../views/pages/splash_page/splash_page.dart';
import '../../../views/pages/login_page/login_page.dart';
import '../../../views/pages/timers_page/timer_homepage.dart';

abstract class Routes {
  static const String LOGIN = '/login';
  static const String HOME = '/home';
  static const String SPLASH = '/splash';
  static const String TIMER = '/timer';
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
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.TIMER,
      page: () => TimerHomePage(),
    ),
  ];
}
