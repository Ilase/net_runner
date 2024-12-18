import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MtDropmenu extends StatelessWidget {
  const MtDropmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$value")));
      },
      color: Colors.white,
      itemBuilder: (context) => [
        _buildPopupMenuItem(Icons.help, "Help", "Help"),
        _buildPopupMenuItem(Icons.help, "Help", "Help"),
        _buildPopupMenuItem(Icons.help, "Help", "Help"),
      ],
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'HelpMenu',
            style: GoogleFonts.comfortaa(),
          ),
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
          Icon(icon, color: Colors.black),
          const SizedBox(
            width: 8,
          ),
          Text(text)
        ],
      ));
}
