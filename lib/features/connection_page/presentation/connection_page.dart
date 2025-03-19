import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/ip_input_formatter.dart';
import 'package:net_runner/core/data/notification/notification_model.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/api_endpoints.dart';
import 'package:net_runner/core/domain/api/api_service_bloc.dart';
import 'package:net_runner/core/domain/data_cubit/data_cubit.dart';
import 'package:net_runner/core/domain/notification_controller/notification_controller_cubit.dart';
import 'package:net_runner/core/domain/notificatioon_controller/notification_controller_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _uriAddress.text = prefs.getString('server_address') ?? '';
      _portController.text = prefs.getString('server_port') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_address', _uriAddress.text);
    await prefs.setString('server_port', _portController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NotificationControllerCubit,
              DataState<List<NotificationModel>>>(
            listener: (context, state) {
              if (state is DataLoadedState<List<NotificationModel>>) {
                final lastNotification = state.data.last;
                NotificationManager().showAnimatedNotification(
                  context,
                  lastNotification.title,
                  lastNotification.body,
                  lastNotification.notificationType,
                );
              }
            },
          ),
          BlocListener<ApiServiceBloc, ApiServiceState>(
            listener: (context, state) {
              if (state is ConnectedToServerState) {
                _saveData();
                Navigator.of(context).pushNamed('/login');
              }
            },
          ),
        ],
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
                    const Text('Адрес сервера'),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Введите адрес и порт сервера',
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
                            ],
                            controller: _uriAddress,
                            decoration: const InputDecoration(
                              labelText: 'Адрес',
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
                                const InputDecoration(labelText: 'Порт'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        if (_uriAddress.text.isNotEmpty &&
                            _portController.text.isNotEmpty) {
                          final endpoints = ApiEndpoints(
                            port: int.parse(_portController.text),
                            host: _uriAddress.text,
                            scheme: "http",
                          );
                          context.read<ApiServiceBloc>().add(
                                ConnectToServerEvent(endpoints: endpoints),
                              );
                        }
                      },
                      label: const Text('Подключиться'),
                      icon: Icon(Icons.login),
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
