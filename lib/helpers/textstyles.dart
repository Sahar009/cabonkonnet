import 'package:cabonconnet/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle body({
    Color? color,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double size = 18,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      letterSpacing: 0.1,
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
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      letterSpacing: 0.1,
      fontWeight: fontWeight,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }

  static TextStyle get soraBody => GoogleFonts.sora(
        fontSize: 14,
        color: AppColor.primaryColor,
        fontWeight: FontWeight.bold,
      );
}
