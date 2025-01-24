import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/core/presentation/widgets/dialog_tile.dart';
import 'dart:convert';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:http/http.dart' as http;

class MtDialogSendScanRequest extends StatefulWidget {
  const MtDialogSendScanRequest({super.key});

  @override
  State<MtDialogSendScanRequest> createState() =>
      _MtDialogSendScanRequestState();
}

class _MtDialogSendScanRequestState extends State<MtDialogSendScanRequest> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetsController = TextEditingController();
  final TextEditingController _portsController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  String _selectedType = 'pentest';
  void WSsendScanRequest() async {
    final String targets = _targetsController.text;
    final String ports = _portsController.text;
    final String speed = _speedController.text;
    if (targets.isEmpty || ports.isEmpty || speed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          'Пожалуйста, заполните все поля',
          //style: AppTheme.lightTheme.textTheme.titleLarge,
        )),
      );
      return;
    }
    final DateTime now = DateTime.now();
    final String formattedDateTime =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    Map<String, dynamic> jsonMessage = {
      "uid": 10101,
      "request_time": formattedDateTime,
      "hosts": [targets],
      "ports": [ports],
      "speed": speed
    };
    String jsonString = jsonEncode(jsonMessage);
    context.read<WebSocketBloc>().add(WebSocketSendMessage(jsonString));
    _targetsController.clear();
    _portsController.clear();
    _speedController.clear();

  }

  @override
  void dispose() {
    _portsController.clear();
    _nameController.clear();
    _speedController.clear();
    _targetsController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostRequestBloc, PostRequestState>(
  listener: (context, state) {
    if(state is PostRequestLoadFailureState ){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ' + state.error)));
    }
    if(state is PostRequestLoadSingleSuccessState){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Loaded')));
    }
  },
  child: MtOpenDialogButton(
      dialogueTitle: 'Новое сканирование*',
      buttonTitle: 'Сканировать*',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Имя сканирования*'),
              readOnly: false,
            ),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(labelText: 'Type'),
              items: ['pentest', 'nmap'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a type';
                }
                return null;
              },
            ),
            TextField(
              controller: _targetsController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Цели сканирования*'),
              readOnly: false,
            ),
            TextField(
              controller: _portsController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Порты(через запятую)*'),
              readOnly: false,
            ),
            TextField(
              controller: _speedController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Скорость сканирования (1-5)*'),
              readOnly: false,
            ),
            OutlinedButton(
              style: const ButtonStyle(),
              onPressed: (){

                final hosts = _targetsController.text.split(',').map((e) => e.trim()).toList();
                final ports = _portsController.text.split(',').map((e) => e.trim()).toList();
                print(hosts.toString());
                print(ports.toString());
                final speed = _speedController.text;     е все поля')),
                  );
                  return;
                }
                context.read<PostRequestBloc>().add(
                    PostRequestSendEvent(
                        endpoint: '/task',
                        body: {
                          "name": _nameController.text,
                          "hosts": hosts,
                          "type": _selectedType,
                          "params": {
                            "ports": _portsController.text,
                            "script": 'default',
                            "speed": _speedController.text,
                          }
                        }
                    )
                );
                _nameController.clear();
                _targetsController.clear();
                _portsController.clear();
                _speedController.clear();
              },
              child:  Text(
                'Запустить сканирование*',
                style: AppTheme.lightTheme.textTheme.labelSmall,
              ),
            )
          ],
        ),
      ),
    ),
);
  }
}
