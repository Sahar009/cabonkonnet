import 'package:cabonconnet/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AppTextStyle {
  static TextStyle body({
    Color? color,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double size = 18,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.sora(
      fontSize: size,
      color: color,
      letterSpacing: 1,
      fontWeight: fontWeight,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }

  static TextStyle header({
    Color? color,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double size = 18,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.sora(
      fontSize: size,
      color: color,
      letterSpacing: 0.5,
      fontWeight: fontWeight,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }

  static TextStyle soraBody({
    Color? color = AppColor.primaryColor,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double size = 14,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.sora(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: 0.9,
        decoration: decoration);
  }
}
