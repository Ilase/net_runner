import 'dart:io';
import 'package:flutter/material.dart';
import 'package:net_runner/pages/mt_headpage.dart';
import 'package:net_runner/pages/mt_splash_screen.dart';

void main() {
  String os = Platform.operatingSystem;
  //print(_os);
  runApp(runStartPoint(platform: os));
  // SplashLoadingScreen(
  //   key: UniqueKey(),
  //   platform: os,
  //   oninitializationComplete: () => runStartPoint()));
}

// void runStartPoint() {
//   runApp(const MaterialApp(home: _createRoute(MtHeadpage())));
// }

class runStartPoint extends StatelessWidget {
  const runStartPoint({super.key, required this.platform});
  final String platform;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: SplashLoadingScreen(
          oninitializationComplete: () {
            navigatorKey.currentState
                ?.pushReplacement(createRoute(const MtHeadpage()));
            //Navigator.pushReplacement(context, createRoute(MtHeadpage()));
          },
          platform: platform),
    );
  }
}

Route createRoute(page) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.1);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}
