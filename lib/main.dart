import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:net_runner/core/domain/cache_operator/cache_operator_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/features/scanning/presentation/scan_view_page.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/core/data/data_loader.dart';
import 'package:net_runner/core/presentation/head_page.dart';
import 'package:net_runner/features/splash_screen/splash_screen.dart';
import 'package:net_runner/utils/routes/routes.dart';
import 'package:platform_detector/widgets/platform_type_widget.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

// String _platform_ = "Unknown";
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(StartPoint(sharedPreferences: sharedPreferences,));
}

class StartPoint extends StatelessWidget {
  //
  StartPoint({super.key, required this.sharedPreferences});
  final SharedPreferences sharedPreferences;
  static var logger = Logger(printer: PrettyPrinter());
  static String platform = "Unknown";
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  late Map<String, dynamic> jsonData;
  Future<void> _loadJsonString() async {
    this.jsonData = jsonDecode(
        await rootBundle.loadString('assets/report.json')
    ) as Map<String, dynamic>;
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _loadJsonString();
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostRequestBloc>(create: (context) => PostRequestBloc()),
        BlocProvider<WebSocketBloc>(create: (context) => WebSocketBloc()),
        BlocProvider<CacheOperatorBloc>(create: (context) => CacheOperatorBloc(sharedPreferences: sharedPreferences))
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
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
              // web: ScanViewPage(jsonData: this.jsonData,),
              // desktop: ScanViewPage(jsonData: this.jsonData,),
              web: HeadPage(),
              desktop: HeadPage(),
              //mobile: null,
            )));

          },
        ),
      ),
    );
  }
}

