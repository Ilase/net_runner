import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/utils/constants/themes/buttons_themes.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme{
    return ThemeData(
      //colors
      // primaryColor: Colors.white,
      // scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white, //scaffold color
          onPrimary: Colors.black,
          secondary: Colors.grey, //color for shapes
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.blue, //color for icons
          ),
      //appbar theme
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.comfortaa(
            color: Colors.white,
          )
      ),
      //text styles
      textTheme: AppTextStyle.lightTextTheme,
     // popupMenuTheme: AppButtonStyle.actionsButtonsTheme,
    );
  }
}