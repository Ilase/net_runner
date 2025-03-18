import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextTheme lightTextTheme = TextTheme(
      titleLarge: GoogleFonts.openSans(fontSize: 36, color: Colors.black),
      titleMedium: GoogleFonts.openSans(fontSize: 24, color: Colors.black),
      titleSmall: GoogleFonts.openSans(fontSize: 16, color: Colors.black),
      headlineMedium: GoogleFonts.openSans(fontSize: 18, color: Colors.white),
      headlineSmall: GoogleFonts.openSans(fontSize: 14, color: Colors.white),
      labelSmall: GoogleFonts.openSans(fontSize: 12, color: Colors.black),
      bodyMedium: GoogleFonts.openSans(fontSize: 16, color: Colors.black),
      bodySmall: GoogleFonts.openSans(fontSize: 12, color: Colors.black),
      displaySmall: GoogleFonts.openSans(fontSize: 12, color: Colors.white));
  // static const titleText = AutoSizeText(
  //   'NetRunner',
  //   minFontSize: 36,
  //   maxFontSize: 48,
  //   overflow: TextOverflow.ellipsis,
  // );
}
