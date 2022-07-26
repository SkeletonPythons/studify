import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class GC extends GetxController {
  static final GC to = Get.find<GC>();
  final Logger logger = Logger();

  /// Verbose logging.
  static void v(String? message, [Object? error, StackTrace? stackTrace]) {
    to.logger.v(message, error, stackTrace);
  }

  /// Debug logging.
  static void d(String? message, [Object? error, StackTrace? stackTrace]) {
    to.logger.d(message, error, stackTrace);
  }

  /// Info logging.
  static void i(String? message, [Object? error, StackTrace? stackTrace]) {
    to.logger.i(message, error, stackTrace);
  }

  /// Warning logging.
  static void w(String? message, [Object? error, StackTrace? stackTrace]) {
    to.logger.w(message, error, stackTrace);
  }

  /// Error logging.
  static void e(String? message, [Object? error, StackTrace? stackTrace]) {
    to.logger.e(message, error, stackTrace);
  }

  /// What the fuck logging. (Critical error)
  static void wtf(String? message, [Object? error, StackTrace? stackTrace]) {
    to.logger.wtf(message, error, stackTrace);
  }

  /// App's accent color.
  final Rx<Color> _accent = Rx<Color>(Colors.redAccent);

  /// [_accent] getter.
  static Rx<Color> get accent => GC.to._accent;

  /// [_accent] setter.
  static void setAccent(Color value) => accent.value = value;

  Rx<TextStyle> textStyle(
      {TextStyle? textstyle,
      double? fontSize,
      Color? fontColor,
      FontWeight? fontWeight}) {
    return Rx<TextStyle>(textstyle ??
        GoogleFonts.ubuntu(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: fontColor ?? Colors.white,
        ));
  }

  /// [_ubuntu] getter.
  static Rx<TextStyle> ubuntu(
          {double? fontSize, Color? fontColor, FontWeight? fontWeight}) =>
      GC.to.textStyle(
          fontColor: fontColor, fontSize: fontSize, fontWeight: fontWeight);
}
