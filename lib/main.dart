import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:net_runner/pages/mt_splash_screen.dart';

void main() {
  String os = Platform.operatingSystem;
  //print(_os);
  runApp(SplashLoadingScreen(
      key: UniqueKey(),
      platform: os,
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
