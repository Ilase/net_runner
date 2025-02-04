
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/data/platform.dart';
import 'package:net_runner/core/domain/post_request_native/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/features/init_ws_connection_page/presentation/init_ws_connection_page_native.dart';
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
  ntLogger.i('Is web: ' + platform.toString());
  final ElementBloc elementBloc = ElementBloc();
  final WebSocketBloc webSocketBloc = WebSocketBloc(elementBloc);
  final PostRequestBloc postRequestBloc = PostRequestBloc(elementBloc);//HttpBloc(elementBloc);
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    StartPoint(
      sharedPreferences: sharedPreferences,
      elementBlocPtr: elementBloc,
      postRequestBlocPtr: postRequestBloc,
      webSocketBlocPtr: webSocketBloc,
    )
  );
}

class StartPoint extends StatelessWidget {
  //
  final ElementBloc elementBlocPtr;
  final WebSocketBloc webSocketBlocPtr;
  final PostRequestBloc postRequestBlocPtr;

  const StartPoint(
    {
      super.key, required this.elementBlocPtr,
      required this.postRequestBlocPtr,
      required this.webSocketBlocPtr ,
      required this.sharedPreferences,
    }
  );

  final SharedPreferences sharedPreferences;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    ntLogger.i('enter point of app');
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: postRequestBlocPtr), //<PostRequestBloc>(create: (context) => PostRequestBloc()),
        BlocProvider.value(value: webSocketBlocPtr), //<WebSocketBloc>(create: (context) => WebSocketBloc()),
        BlocProvider.value(value: elementBlocPtr), //<CacheOperatorBloc>(create: (context) => CacheOperatorBloc(sharedPreferences: sharedPreferences)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: AppTheme.lightTheme,
        //locales
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        //!locales
        navigatorKey: navigatorKey,
        home: SplashLoadingScreen(
          //load tasks in queue or
          loader: TaskLoader(tasks: []),
          onInitializationComplete: () async {
            navigatorKey.currentState
                ?.pushReplacement(createRoute(const PlatformDetectByType(
              web: InitWsConnectionPage(),
              desktop: InitWsConnectionPage(),

            )));

          },
        ),
        routes: {
          InitWsConnectionPage.route : (context) => const InitWsConnectionPage(),
          HeadPage.route : (context) => HeadPage(),
        },
      ),
    );
  }
}

