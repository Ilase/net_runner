import 'dart:io';
import 'package:flutter/material.dart';
import 'package:net_runner/pages/mt_headpage.dart';
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
  runApp(const MaterialApp(home: MtHeadpage()));
}
