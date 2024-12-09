import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_scanner_test_client/material/material_start.dart';
import 'package:net_scanner_test_client/main.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback oninitializationComplete;
  const SplashScreen({super.key, required this.oninitializationComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAsyncDependencies();
  }

  Future<void> _initializeAsyncDependencies() async {
    Future.delayed(const Duration(milliseconds: 1500),
        () => widget.oninitializationComplete());
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
          color: Colors.white,
          child: IconButton(
              onPressed: () => main(), icon: Icon(Icons.layers_rounded)));
    }
    return Container(
      color: Colors.white,
      child: Center(
        child: LoadingAnimationWidget.stretchedDots(
          color: Colors.blue,
          size: 120,
        ),
      ),
    );
  }
}
