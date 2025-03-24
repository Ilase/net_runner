import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/data_loader.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/notificatioon_controller/notification_controller_cubit.dart';
import 'package:net_runner/core/domain/pentest_report_controller/pentest_report_controller_cubit.dart';
import 'package:net_runner/core/domain/ping_list/ping_list_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:net_runner/core/domain/theme_controller/theme_controller_cubit.dart';
import 'package:net_runner/core/domain/user_repository/user_data_cubit.dart';
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

import 'core/domain/profile_page/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  HostListCubit hostListCubit = HostListCubit();
  GroupListCubit groupListCubit = GroupListCubit();
  TaskListCubit taskListCubit = TaskListCubit();
  ReportControllerCubit pentestReportControllerCubit = ReportControllerCubit();
  NotificationControllerCubit notificationControllerCubit =
      NotificationControllerCubit();
  PingListCubit pingListCubit = PingListCubit();
  UserDataCubit userDataCubit = UserDataCubit();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => ThemeControllerCubit()),
      BlocProvider.value(value: notificationControllerCubit),
      BlocProvider.value(value: pentestReportControllerCubit),
      BlocProvider.value(value: pingListCubit),
      BlocProvider.value(value: groupListCubit),
      BlocProvider.value(value: hostListCubit),
      BlocProvider.value(value: taskListCubit),
      BlocProvider.value(value: userDataCubit),
      BlocProvider(
        create: (context) => ApiBloc(
          userDataCubit: userDataCubit,
          notificationControllerCubit: notificationControllerCubit,
          pingListCubit: pingListCubit,
          taskListCubit: taskListCubit,
          hostListCubit: hostListCubit,
          groupListCubit: groupListCubit,
          reportControllerCubit: pentestReportControllerCubit,
        ),
      ),
    ],
    child: StartPoint(
      sharedPreferences: sharedPreferences,
    ),
  ));
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
