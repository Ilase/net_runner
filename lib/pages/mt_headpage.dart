import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/modules/mt_dropmenu.dart';

class MtHeadpage extends StatefulWidget {
  const MtHeadpage({super.key});

  @override
  State<MtHeadpage> createState() => _MtHeadpageState();
}

class _MtHeadpageState extends State<MtHeadpage> {
  //late PageController _pageController;
  // int _selectedIndex = 0;
  String version = '';
  String platform = '';

  // @override
  // void initState(){
  //   super.initState();
  //   _getMetaInfo();
  // };

  // _getMetaInfo() async {
  //   final packageInfo = await PackageInfo
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main Navigator
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
        actions: const [MtDropmenu()],
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Text(
              'data',
              style: GoogleFonts.comfortaa(color: Colors.black54),
            ),
          )),
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
                        onPressed: () {
                          setState(() {});
                        },
                        icon: const Icon(Icons.home),
                        color: Colors.white,
                      ),
                      IconButton(
                        iconSize: 56,
                        onPressed: () {},
                        focusColor: Colors.white10,
                        icon: const Icon(Icons.radar),
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
            // const MtContentTileBottom()
            // Container(
            //   decoration: BoxDecoration(boxShadow: const [
            //     BoxShadow(
            //         color: Colors.black26, offset: Offset(3, 6), blurRadius: 4)
            //   ], borderRadius: BorderRadius.circular(15), color: Colors.blue),
            //   child: Center(
            //     child: Text("this is page namba: ${_selectedIndex}"),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
