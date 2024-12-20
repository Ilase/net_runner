import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_runner/modules/data_loader.dart';
//import 'package:net_runner/main.dart';

class SplashLoadingScreen extends StatefulWidget {
  final VoidCallback oninitializationComplete;
  final TaskLoader loader;

  const SplashLoadingScreen(
      {super.key,
      required this.oninitializationComplete,
      required this.loader});

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
      ///@Ilase !!! important thisng
      await widget.loader.runInParallel();
      await Future.delayed(const Duration(seconds: 5), () {
        widget.oninitializationComplete();
        //Navigator.pushReplacement(context, _createRoute(MtHeadpage()));
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      print(e.toString());
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
                      const SizedBox(
                        height: 10,
                      ),
                      Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text('Loading',
                              style: GoogleFonts.comfortaa(
                                  color: Colors.blue, fontSize: 24)))
                    ],
                  )));
  }
}
