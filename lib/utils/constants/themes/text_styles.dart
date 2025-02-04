import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextTheme lightTextTheme =  TextTheme(
      titleLarge: GoogleFonts.notoSansBuhid(fontSize: 44, color: Colors.white),
      titleMedium: GoogleFonts.notoSansBuhid(fontSize: 32, color: Colors.blue),
      titleSmall: GoogleFonts.notoSansBuhid(fontSize: 16, color: Colors.white),
      headlineMedium: GoogleFonts.notoSansBuhid(fontSize: 18, color: Colors.white),
      headlineSmall: GoogleFonts.notoSansBuhid(fontSize: 14, color: Colors.white),
      labelSmall: GoogleFonts.notoSansBuhid(fontSize: 12, color: Colors.blue),
      bodyMedium: GoogleFonts.notoSansBuhid(fontSize: 28, color: Colors.blue),
      bodySmall: GoogleFonts.notoSansBuhid(fontSize: 12, color: Colors.black),
      displaySmall: GoogleFonts.notoSansBuhid(fontSize: 12, color: Colors.white)
  );
  // static const titleText = AutoSizeText(
  //   'NetRunner',
  //   minFontSize: 36,
  //   maxFontSize: 48,
  //   overflow: TextOverflow.ellipsis,
  // );

}

