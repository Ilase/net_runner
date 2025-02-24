import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextTheme lightTextTheme = TextTheme(
      titleLarge: GoogleFonts.comfortaa(fontSize: 44, color: Colors.white),
      titleMedium: GoogleFonts.comfortaa(fontSize: 32, color: Colors.blue),
      titleSmall: GoogleFonts.comfortaa(fontSize: 16, color: Colors.white),
      headlineMedium: GoogleFonts.comfortaa(fontSize: 18, color: Colors.white),
      headlineSmall: GoogleFonts.comfortaa(fontSize: 14, color: Colors.white),
      labelSmall: GoogleFonts.comfortaa(fontSize: 12, color: Colors.blue),
      bodyMedium: GoogleFonts.comfortaa(fontSize: 16, color: Colors.blue),
      bodySmall: GoogleFonts.comfortaa(fontSize: 12, color: Colors.black),
      displaySmall: GoogleFonts.comfortaa(fontSize: 12, color: Colors.white));
  // static const titleText = AutoSizeText(
  //   'NetRunner',
  //   minFontSize: 36,
  //   maxFontSize: 48,
  //   overflow: TextOverflow.ellipsis,
  // );
}
