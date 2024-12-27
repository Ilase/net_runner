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
          primary: Colors.blue, //scaffold color
          onPrimary: Colors.white,
          secondary: Colors.grey, //color for shapes
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white, //color for cards and other buttons(filter, scanning)
          onSurface: Colors.blue, //color for icons
          ),
      //appbar theme
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
      ),
      //text styles
      textTheme: AppTextStyle.lightTextTheme,
     // popupMenuTheme: AppButtonStyle.actionsButtonsTheme,
    );
  }
}