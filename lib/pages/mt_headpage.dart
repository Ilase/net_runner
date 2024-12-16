import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/modules/mt_navigation_rail.dart';

class MtHeadpage extends StatefulWidget {
  const MtHeadpage({super.key});

  @override
  State<MtHeadpage> createState() => _MtHeadpageState();
}

class _MtHeadpageState extends State<MtHeadpage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            IntrinsicHeight(
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 6),
                            blurRadius: 4)
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 56,
                        onPressed: () {},
                        icon: Icon(Icons.home),
                        color: Colors.white,
                      ),
                      IconButton(
                        iconSize: 56,
                        onPressed: () {},
                        focusColor: Colors.white10,
                        icon: Icon(Icons.radar),
                        color: Colors.white,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
