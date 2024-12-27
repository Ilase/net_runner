import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

// ignore: must_be_immutable
class MtDropmenu extends StatelessWidget {
  MtDropmenu({super.key, this.title});
  String? title;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$value")));
      },
      itemBuilder: (context) => [
        _buildPopupMenuItem(Icons.help, "Help", "Help"),
        _buildPopupMenuItem(Icons.help, "Help", "Help"),
        _buildPopupMenuItem(Icons.help, "Help", "Help"),
      ],
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: Colors.white)),
        padding: const EdgeInsets.all(8.0),
        child: Text(
            title!,
            style: AppTheme.lightTheme.textTheme.displaySmall,
          ),
        ),
    );
  }
}

PopupMenuItem _buildPopupMenuItem(IconData icon, String text, String value) {
  return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: AppTheme.lightTheme.colorScheme.onSurface),
          const SizedBox(
            width: 8,
          ),
          Text(text , style: AppTheme.lightTheme.textTheme.bodySmall)
        ],
      ));
}
