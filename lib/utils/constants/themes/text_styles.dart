import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextTheme lightTextTheme =  TextTheme(
    //appbar title
      titleLarge: GoogleFonts.comfortaa(fontSize: 48, color: Colors.white),
      //title of page or part
      titleMedium: GoogleFonts.comfortaa(fontSize: 36, color: Colors.black),
      //title of card with info
      headlineSmall: GoogleFonts.comfortaa(fontSize: 20, color: Colors.white),
      //label of menu buttons
      labelSmall: GoogleFonts.comfortaa(fontSize: 12, color: Colors.blue),

      bodyMedium: GoogleFonts.comfortaa(fontSize: 28, color: Colors.white),
      //text in buttons and titles in tables
      bodySmall: GoogleFonts.comfortaa(fontSize: 14, color: Colors.black),
      //text info in cards and tables
      displaySmall: GoogleFonts.comfortaa(fontSize: 12, color: Colors.white)
  );
  // static const titleText = AutoSizeText(
  //   'NetRunner',
  //   minFontSize: 36,
  //   maxFontSize: 48,
  //   overflow: TextOverflow.ellipsis,
  // );

}