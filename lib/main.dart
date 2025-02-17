
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/api_service/api_service.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/data/platform.dart';
import 'package:net_runner/core/domain/api/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/api/ping_list/ping_list_cubit.dart';
import 'package:net_runner/core/domain/api_data_controller/api_data_controller_bloc.dart';
import 'package:net_runner/core/domain/checkbox_controller/checkbox_controller_bloc.dart';
import 'package:net_runner/core/domain/connection_init/connection_init_bloc.dart';
import 'package:net_runner/core/domain/graph_request/graph_request_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/features/hosts/presentation/add_host_page.dart';
import 'package:net_runner/features/init_ws_connection_page/presentation/init_ws_connection_page_native.dart';
import 'package:net_runner/features/scanning/presentation/create_scan_page.dart';
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
  ntLogger.i('Is web: $platform');

  ApiService apiService = ApiService(baseUrl: null);
  final HostListCubit hostListCubit = HostListCubit();
  final ElementBloc elementBloc = ElementBloc();
  final PingListCubit pingListCubit = PingListCubit();
  final ApiDataControllerBloc apiDataControllerBloc = ApiDataControllerBloc(apiService: apiService, hostListCubit: hostListCubit, pingListCubit: pingListCubit);
  //final WebSocketBloc webSocketBloc = WebSocketBloc(elementBloc);
  //final PostRequestBloc postRequestBloc = PostRequestBloc(elementBloc, apiDataControllerBloc);
  final CheckboxControllerBloc checkboxControllerBloc = CheckboxControllerBloc();
  final ConnectionInitBloc connectionInitBloc = ConnectionInitBloc();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: pingListCubit),
        BlocProvider.value(value: elementBloc),
        BlocProvider.value(value: apiDataControllerBloc),
        BlocProvider.value(value: hostListCubit),
        BlocProvider(create: (context) => GraphRequestBloc()),
        BlocProvider(create: (context) => PostRequestBloc(elementBloc, apiDataControllerBloc)),
        BlocProvider(create: (context) => WebSocketBloc(elementBloc)),
        BlocProvider(create: (context) => CheckboxControllerBloc()),
        BlocProvider(create: (context) => ConnectionInitBloc()),
      ],
      child: StartPoint(
        sharedPreferences: sharedPreferences,
        // elementBlocPtr: elementBloc,
        // postRequestBlocPtr: postRequestBloc,
        // webSocketBlocPtr: webSocketBloc,
        // checkboxControllerBlocPtr: checkboxControllerBloc,
        // connectionInitBloc: connectionInitBloc,
      ),
    )
  );
}

class StartPoint extends StatelessWidget {
  //
  // final ElementBloc elementBlocPtr;
  // final WebSocketBloc webSocketBlocPtr;
  // final PostRequestBloc postRequestBlocPtr;
  // final CheckboxControllerBloc checkboxControllerBlocPtr;
  // final ConnectionInitBloc connectionInitBloc;


  const StartPoint(
    {
      super.key,
      // required this.elementBlocPtr,
      // required this.postRequestBlocPtr,
      // required this.webSocketBlocPtr ,
      required this.sharedPreferences,
      // required this.checkboxControllerBlocPtr,
      // required this.connectionInitBloc,
    }
  );

  final SharedPreferences sharedPreferences;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    ntLogger.i('enter point of app');
    return MaterialApp(
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
          AddHostPage.route : (context) => const AddHostPage(),
          CreateScanPage.route : (context) => const CreateScanPage()
        },
    );
  }
}

