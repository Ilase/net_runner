import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/api_endpoints.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/pentest_report_controller/pentest_report_controller_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';

void main() {
  PentestReportControllerCubit pentestReportControllerCubit =
      PentestReportControllerCubit();
  runApp(
    BlocProvider(
      create: (context) => ApiBloc(
        hostListCubit: HostListCubit(),
        groupListCubit: GroupListCubit(),
        taskListCubit: TaskListCubit(),
        //pentestReportControllerCubit: pentestReportControllerCubit,
      ),
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<ApiBloc>().add(ConnectToServerEvent(
        endpoints:
            ApiEndpoints(host: "192.168.20.193", port: 3002, scheme: "http")));
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            context
                .read<ApiBloc>()
                .add(GetPentestReportEvent(taskName: "TASK-00059"));
          },
          icon: Icon(Icons.get_app),
        ),
      ),
    );
  }
}
