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
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.blue, //scaffold color
          onPrimary: Colors.white,
          secondary: Colors.grey, //color for shapes
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.blue,
          ),
      //appbar theme
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
      ),
      //text styles
      textTheme: AppTextStyle.lightTextTheme,
      elevatedButtonTheme: AppButtonStyle.modalWindowButtonTheme
     // popupMenuTheme: AppButtonStyle.actionsButtonsTheme,
    );
  }
}