import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../consts/app_colors.dart';

Rx<ThemeData> currentTheme = themeOne.obs;

Rx<TextStyle> currentStyle = textStyleOne.obs;

final ThemeData themeOne = ThemeData.dark().copyWith(
  primaryColor: kPrimary,
  backgroundColor: kBackground,
  primaryColorDark: kAccent,
  brightness: Brightness.dark,
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
