import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class AppButtonStyle {
  /// cancel, apply and other
  static ElevatedButtonThemeData modalWindowButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      //backgroundColor: Color(0xEAE8E8),
      //foregroundColor: Colors.black,
      disabledBackgroundColor: Colors.grey,
      elevation: 5,
      textStyle: GoogleFonts.comfortaa(fontSize: 14, color: Colors.blue),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      fixedSize: Size(130, 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      )
    )
  );

/// --actions buttons on appbar
//   static PopupMenuThemeData actionsButtonsTheme = PopupMenuThemeData(
//     color: Colors.white,
//     textStyle: GoogleFonts.comfortaa(color: Colors.black),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(1)
//     ),
//     elevation: 5,
//
//   );

}

// style: ElevatedButton.styleFrom(
// backgroundColor: Color(0xEAE8E8),
// foregroundColor: Colors.black,
// disabledBackgroundColor: Colors.grey,
// elevation: 5,
// textStyle: AppTheme.lightTheme.textTheme.bodySmall,
// padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
// fixedSize: Size(110, 10),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10)
// )