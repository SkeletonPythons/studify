import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/consts/app_colors.dart';

Rx<ThemeData> currentTheme = themeOne.obs;

Rx<TextStyle> currentStyle = textStyleOne.obs;

final ThemeData themeOne = ThemeData.dark().copyWith(
  primaryColor: kPrimary,
  backgroundColor: kBackground,
  primaryColorDark: kAccent,
  brightness: Brightness.dark,
  tabBarTheme: ThemeData.dark().tabBarTheme.copyWith(
        labelColor: kAccent,
        unselectedLabelColor: Colors.white,
        labelStyle: GoogleFonts.ubuntu(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: kAccent,
        ),
      ),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: kPrimary,
    secondary: kAccent,
    surface: kBackground,
    background: kBackground,
    onPrimary: kBackground,
    onSecondary: kBackground,
    onSurface: kBackground,
    onBackground: kBackground,
    onError: kBackground,
    brightness: Brightness.light,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all<double>(4),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.all(24),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(kBackgroundLight2),
      foregroundColor: MaterialStateProperty.all<Color>(kAccent),
    ),
  ),
);

final TextStyle textStyleOne = GoogleFonts.ubuntuMono(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: kPrimary,
);

final ThemeData appThemeData = ThemeData.dark().copyWith(
    primaryColor: bkgnds[1],
    backgroundColor: bkgnds[1],
    scaffoldBackgroundColor: bkgnds[1],
    textTheme: textTheme);

final TextTheme textTheme = GoogleFonts.ubuntuMonoTextTheme().copyWith(
  headline1: GoogleFonts.ubuntuMono(
      fontSize: 72.0, fontWeight: FontWeight.bold, color: txts[1]),
  headline2: GoogleFonts.ubuntuMono(
      fontSize: 36.0, fontWeight: FontWeight.normal, color: txts[2]),
  headline3: GoogleFonts.neucha(
      fontSize: 24.0, fontWeight: FontWeight.bold, color: txts[3]),
  headline4: GoogleFonts.neucha(
      fontSize: 18.0, fontWeight: FontWeight.normal, color: txts[4]),
  headline5: GoogleFonts.ubuntuMono(
      fontSize: 14.0, fontWeight: FontWeight.bold, color: txts[5]),
  headline6: GoogleFonts.neucha(
      fontSize: 12.0, fontWeight: FontWeight.normal, color: txts[6]),
  subtitle1: GoogleFonts.ubuntuMono(
      fontSize: 18.0, fontWeight: FontWeight.normal, color: txts[1]),
  subtitle2: GoogleFonts.ubuntuMono(
      fontSize: 14.0, fontWeight: FontWeight.normal, color: txts[2]),
  bodyText1: GoogleFonts.ubuntuMono(
      fontSize: 18.0, fontWeight: FontWeight.normal, color: txts[3]),
  bodyText2: GoogleFonts.neucha(
      fontSize: 14.0, fontWeight: FontWeight.normal, color: txts[4]),
  button: GoogleFonts.ubuntuMono(
      fontSize: 14.0, fontWeight: FontWeight.bold, color: txts[5]),
  caption: GoogleFonts.neucha(
      fontSize: 12.0, fontWeight: FontWeight.normal, color: txts[6]),
  overline: GoogleFonts.ubuntuMono(
      fontSize: 12.0, fontWeight: FontWeight.normal, color: txts[1]),
);

const Map<int, Color> bkgnds = {
  1: Color(0xff1a1a1a),
  2: Color(0xff313131),
  3: Color(0xff424242),
  4: Color(0xff616161),
  5: Color(0xff717171),
  6: Color(0xff828282),
  7: Color(0xff929292),
  8: Color(0xffa3a3a3),
  9: Color(0xffb4b4b4),
};

const Map<int, Color> acnts = {
  1: Color.fromARGB(255, 173, 186, 255),
  2: Color.fromARGB(255, 255, 52, 235),
  3: Color.fromARGB(255, 60, 255, 77),
  4: Color.fromARGB(255, 164, 178, 255),
  5: Color.fromARGB(255, 117, 195, 240),
  6: Color(0xffEEB76B),
  7: Color.fromARGB(255, 59, 206, 142),
  8: Color.fromARGB(255, 255, 90, 48),
  9: Color(0xffE5A5FF),
  10: Color(0xffabcbbe)
};

const Map<int, Color> brdrs = {
  1: Color(0xffF6D7A7),
  2: Color(0xffC37B89),
  3: Color(0xff6D8299),
  4: Color(0xffCAB8FF),
};

const Map<int, Color> txts = {
  1: Color(0xffF9F3DF),
  2: Color(0xffFDFCE5),
  3: Color(0xffD7E9F7),
  4: Color(0xffF4D19B),
  5: Color(0xffFEFBF3),
  6: Color(0xff9D9D9D),
  7: Color(0xffCAB8FF),
};
