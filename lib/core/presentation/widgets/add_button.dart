import 'package:flutter/material.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class MtAddButton extends StatelessWidget {
  MtAddButton({super.key,
    required this.onPressed,
    required this.child});
  VoidCallback onPressed;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
            Icons.add_circle_outline,
            size: 30)
    );
  }

  void _showCustomDialog(BuildContext context) { //open dialog window
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),

          elevation: 0, // Тень
          backgroundColor: Colors.white,
          child: child
          //contentBox(context),
        );
      },
    );
  }
}
