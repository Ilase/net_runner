import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MtAppbar extends StatefulWidget implements PreferredSizeWidget {
  const MtAppbar({super.key});

  @override
  State<MtAppbar> createState() => _MtAppbarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MtAppbarState extends State<MtAppbar> {
  // @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AppBar(
        title: const AutoSizeText(
          'NetRunner',
          minFontSize: 36,
          maxFontSize: 48,
          overflow: TextOverflow.ellipsis,
        ),
        titleTextStyle: GoogleFonts.comfortaa(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // FloatingActionButton(onPressed: () {}),

          OutlinedButton(
              onPressed: () {},
              child: Text('Next', style: GoogleFonts.comfortaa())),
        ],
      );
    });
  }
}
