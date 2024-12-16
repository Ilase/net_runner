import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_runner/modules/mt_router.dart' as router;
import 'package:net_runner/pages/mt_headpage.dart';
//import 'package:net_runner/main.dart';

Route _createRoute(page) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.1);
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

class SplashLoadingScreen extends StatefulWidget {
  final VoidCallback oninitializationComplete;
  final String platform;
  const SplashLoadingScreen(
      {super.key,
      required this.oninitializationComplete,
      required this.platform});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAsyncDependencies();
  }

  Future<void> _initializeAsyncDependencies() async {
    try {
      ///
      ///
      /// initialization of connection to server and other!
      ///
      ///
      await Future.delayed(const Duration(seconds: 5), () {
        widget.oninitializationComplete();
        Navigator.pushReplacement(context, _createRoute(MtHeadpage()));
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: _hasError
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                      });
                      _initializeAsyncDependencies();
                    },
                    icon: const Icon(Icons.refresh),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 125,
                          height: 125,
                          alignment: const Alignment(10, 10),
                          child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: LoadingAnimationWidget.stretchedDots(
                                  color: Colors.blue, size: 125))),
                      Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text('Loading',
                              style: GoogleFonts.comfortaa(
                                  color: Colors.blue, fontSize: 24)))
                    ],
                  )));
  }
}
