import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextTheme lightTextTheme =  TextTheme(
      titleLarge: GoogleFonts.comfortaa(fontSize: 48, color: Colors.white), //appbar title
      titleMedium: GoogleFonts.comfortaa(fontSize: 32, color: Colors.blue), //title of page
      headlineSmall: GoogleFonts.comfortaa(fontSize: 20, color: Colors.white), //title of card with info
      labelSmall: GoogleFonts.comfortaa(fontSize: 12, color: Colors.blue),   //label of menu buttons
      bodyMedium: GoogleFonts.comfortaa(fontSize: 28, color: Colors.white),
      bodySmall: GoogleFonts.comfortaa(fontSize: 14, color: Colors.black), //text in buttons and titles in tables
      displaySmall: GoogleFonts.comfortaa(fontSize: 12, color: Colors.white)  //text info in cards, tables and snackbar
  );
  // static const titleText = AutoSizeText(
  //   'NetRunner',
  //   minFontSize: 36,
  //   maxFontSize: 48,
  //   overflow: TextOverflow.ellipsis,
  // );

}