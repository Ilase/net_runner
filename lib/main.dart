import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:net_runner/core/data/xml/xml.dart';
import 'package:net_runner/core/domain/cache_operator/cache_operator_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/core/data/task_loader.dart';
import 'package:net_runner/core/presentation/mt_headpage.dart';
import 'package:net_runner/features/splash_screen/mt_splash_screen.dart';
import 'package:net_runner/utils/routes/routes.dart';
import 'package:platform_detector/widgets/platform_type_widget.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/features/sign_in_page/presentation/mt_sign_in.dart';

// String _platform_ = "Unknown";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(StartPoint(sharedPreferences: sharedPreferences,));
}

class StartPoint extends StatelessWidget {
  //
  const StartPoint({super.key, required this.sharedPreferences});
  final SharedPreferences sharedPreferences;
  static var logger = Logger(printer: PrettyPrinter());
  static String platform = "Unknown";
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  //
  //
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<WebSocketBloc>(create: (context) => WebSocketBloc())
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        //locales
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        //!locales
        navigatorKey: navigatorKey,
        home:

        SplashLoadingScreen(
          //load tasks in queue or
          loader: TaskLoader(tasks: []),
          oninitializationComplete: () async {
            navigatorKey.currentState
                ?.pushReplacement(createRoute(PlatformDetectByType(
              web: MtSignIn(),
              desktop: MtSignIn(),
              mobile: Placeholder(),
            )));
          },
        ),
        routes: {
          MtSignIn.route : (context) => MtSignIn(),
          MtHeadpage.route: (context) => MtHeadpage()
        },
      ),
    );
  }
}
//
// ///TODO:useless shit!! it doesn't work correctly
// Route createRoute(page) {
//   return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(0.0, 1.1);
//         const end = Offset.zero;
//         const curve = Curves.ease;
//
//         var tween =
//             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       });
// }
