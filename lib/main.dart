import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/data_loader.dart';
import 'package:net_runner/core/domain/api/api_service_bloc.dart';
import 'package:net_runner/core/domain/theme_controller/theme_controller_cubit.dart';
import 'package:net_runner/features/connection_page/presentation/connection_page.dart';
import 'package:net_runner/features/head_page/head_page.dart';
import 'package:net_runner/features/hosts/presentation/add_host_page.dart';
import 'package:net_runner/features/login_page/presentation/sign_in_page.dart';
import 'package:net_runner/features/scanning/presentation/create_scan_page.dart';
import 'package:net_runner/features/splash_screen/splash_screen.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/utils/routes/router.dart';
import 'package:platform_detector/widgets/platform_type_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/domain/old_cubits/profile_page/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  ApiServiceBloc apiServiceBloc = ApiServiceBloc();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeControllerCubit()),
      ],
      child: StartPoint(
        sharedPreferences: sharedPreferences,
      ),
    ),
  );
}

class StartPoint extends StatelessWidget {
  const StartPoint({
    super.key,
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: context.watch<ThemeControllerCubit>().state,
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
            web: ConnectionPage(),
            desktop: ConnectionPage(),
          )));
        },
      ),
      routes: {
        ConnectionPage.route: (context) => const ConnectionPage(),
        HeadPage.route: (context) => HeadPage(),
        AddHostPage.route: (context) => const AddHostPage(),
        CreateScanPage.route: (context) => const CreateScanPage(),
        LoginPage.route: (context) => const LoginPage(),
        ProfilePage.route: (context) => const ProfilePage(),
      },
    );
  }
}
