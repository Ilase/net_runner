import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/host_list/host_list_cubit.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => ApiBloc(),
    child: MaterialApp(
      home: HomePage(),
    ),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ApiBloc>().add(GetHosts());
              },
              child: Text(
                'GetHostList',
              ),
            ),
            BlocBuilder<ApiBloc, ApiState>(
              builder: (context, state) {
                final hostState = context.read<ApiBloc>().hostList.state;
                if (state is FullState) {
                  ntLogger.i(hostState.toString());
                  return Text(hostState.hostList.toString());
                } else {
                  return Text('nothing');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
