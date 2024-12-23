import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/core/presentation/widgets/data_loader.dart';
import 'package:net_runner/core/presentation/mt_headpage.dart';
import 'package:net_runner/core/presentation/mt_splash_screen.dart';
import 'package:platform_detector/widgets/platform_type_widget.dart';

// String _platform_ = "Unknown";

void main() {
  // String os = Platform.operatingSystem;

  //print(_os);
  runApp(const StartPoint());
  // SplashLoadingScreen(
  //   key: UniqueKey(),
  //   platform: os,
  //   oninitializationComplete: () => runStartPoint()));
}

// void runStartPoint() {
//   runApp(const MaterialApp(home: _createRoute(MtHeadpage())));
// }

class StartPoint extends StatelessWidget {
  //
  const StartPoint({super.key});
  static var logger = Logger(printer: PrettyPrinter());
  static String platform = "Unknown";
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  //
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //locales
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      //!locales
      navigatorKey: navigatorKey,
      home: SplashLoadingScreen(
        //load tasks in queue or
        loader: TaskLoader(tasks: []),
        oninitializationComplete: () async {
          navigatorKey.currentState
              ?.pushReplacement(createRoute(PlatformDetectByType(
            web: MtHeadpage(
              platform: platform,
            ),
            desktop: MtHeadpage(
              platform: platform,
            ),
            mobile: null,
          )));
          //Navigator.pushReplacement(context, createRoute(MtHeadpage()));
        },
      ),
    );
  }
}

///TODO:useless shit!! it doesn work correctly
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
