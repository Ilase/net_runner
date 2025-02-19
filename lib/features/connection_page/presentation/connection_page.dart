import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/ip_input_formatter.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/api_endpoints.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';

import 'package:net_runner/utils/constants/themes/text_styles.dart';

class ConnectionPage extends StatefulWidget {
  static const String route = '/init';

  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final TextEditingController _uriAddress = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ApiBloc, ApiState>(
        listener: (context, state) {
          if (context.read<ApiBloc>().state is ConnectedState) {
            NotificationManager()
                .showAnimatedNotification(context, 'Commected');
            Navigator.of(context).pushNamed('/head');
          } else if (context.read<ApiBloc>().state is ConnectErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Error')));
          }
        },
        child: Center(
          child: SizedBox(
            width: 500,
            height: 500,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Server address*'),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Enter address with port*',
                      style: AppTextStyle.lightTextTheme.bodySmall,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
                            inputFormatters: [
                              IPTextInputFormatter(),
                              // FilteringTextInputFormatter.allow(RegExp(r'^[\d\.\:]+$')),
                            ],
                            controller: _uriAddress,
                            decoration: const InputDecoration(
                              labelText: 'Local address*',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            inputFormatters: [],
                            controller: _portController,
                            decoration:
                                const InputDecoration(labelText: 'Port*'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_uriAddress.text.isNotEmpty &&
                            _portController.text.isNotEmpty) {
                          final endpoints = ApiEndpoints(
                            port: int.parse(_portController.text),
                            host: _uriAddress.text,
                            scheme: "http",
                          );
                          context.read<ApiBloc>().add(
                                ConnectToServerEvent(endpoints: endpoints),
                              );
                        }
                      },
                      child: const Text('Connect'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
