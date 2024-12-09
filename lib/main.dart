import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:net_scanner_test_client/modules/mt_content_tile.dart';
import 'package:net_scanner_test_client/pages/mt_splash_screen.dart';

void main() {
  String _os = Platform.operatingSystem;
  //print(_os);
  runApp(SplashLoadingScreen(
      key: UniqueKey(),
      platform: _os,
      oninitializationComplete: () => runStartPoint()));
}

void runStartPoint() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: Text(
          'NetRunner',
          style: GoogleFonts.comfortaa(),
        ),
      ),
      body: Center(
        child: Container(),
      ),
    ),
  ));
}
