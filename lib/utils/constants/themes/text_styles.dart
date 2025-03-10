import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextTheme lightTextTheme = TextTheme(
      titleLarge: GoogleFonts.openSans(fontSize: 44, color: Colors.white),
      titleMedium: GoogleFonts.openSans(fontSize: 32, color: Colors.blue),
      titleSmall: GoogleFonts.openSans(fontSize: 16, color: Colors.white),
      headlineMedium: GoogleFonts.openSans(fontSize: 18, color: Colors.white),
      headlineSmall: GoogleFonts.openSans(fontSize: 14, color: Colors.white),
      labelSmall: GoogleFonts.openSans(fontSize: 12, color: Colors.blue),
      bodyMedium: GoogleFonts.openSans(fontSize: 16, color: Colors.blue),
      bodySmall: GoogleFonts.openSans(fontSize: 12, color: Colors.black),
      displaySmall: GoogleFonts.openSans(fontSize: 12, color: Colors.white));
  // static const titleText = AutoSizeText(
  //   'NetRunner',
  //   minFontSize: 36,
  //   maxFontSize: 48,
  //   overflow: TextOverflow.ellipsis,
  // );
}
