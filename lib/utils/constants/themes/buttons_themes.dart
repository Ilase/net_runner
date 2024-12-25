import 'package:flutter/material.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class AppButtonStyle {
  /// cancel, apply and other
  static ElevatedButtonThemeData modalWindowButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xEAE8E8),
      foregroundColor: Colors.black,
      disabledBackgroundColor: Colors.grey,
      elevation: 5,
      textStyle: AppTheme.lightTheme.textTheme.bodySmall,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      fixedSize: Size(90, 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      )
    )
  );

/// --actions buttons on appbar
  static ElevatedButtonThemeData actionsButtonsTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xEAE8E8),
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey,
          elevation: 5,
          textStyle: AppTheme.lightTheme.textTheme.bodySmall,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          fixedSize: Size(110, 25),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          )
      )
  );

}