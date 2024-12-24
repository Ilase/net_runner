import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme{
    return ThemeData(
      //colors
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      //appbar theme
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.comfortaa(
            color: Colors.white,
          )
      ),
      //text styles
      textTheme: AppTextStyle.lightTextTheme
    );
  }
}