import 'package:flutter/material.dart';
import 'package:net_scanner_test_client/material/modules/splash_screen.dart';
import 'package:net_scanner_test_client/material/pages/homepage.dart';

class MaterialEnv extends StatelessWidget {
  const MaterialEnv({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {},
        home: SplashScreen(
          key: UniqueKey(),
          oninitializationComplete: () => MaterialHomepage(),
        ));
  }
}
