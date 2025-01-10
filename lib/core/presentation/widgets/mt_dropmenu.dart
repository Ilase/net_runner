import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

// ignore: must_be_immutable
class MtDropMenu extends StatelessWidget {
  final List<PopupMenuItem> popupMenuItems;
  MtDropMenu({super.key, this.title, required this.popupMenuItems});
  String? title;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text("$value")));
      },
      itemBuilder: (context) => popupMenuItems,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        //width: 80,
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

PopupMenuItem buildPopupMenuItem(IconData icon, String text, String value) {
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
