import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MtContentTileBottom extends StatelessWidget {
  const MtContentTileBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: Container(
            height: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(3, 6),
                      blurRadius: 4),
                ]),
            child: Text(
              'data',
              style: GoogleFonts.comfortaa(),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'data',
              style: GoogleFonts.comfortaa(),
            ),
          ),
        ),
      ],
    );
  }
}
