import 'package:flutter/material.dart';
import 'package:net_runner/core/presentation/widgets/mt_dialog_tile.dart';
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
  final TextEditingController _targetsController = TextEditingController();
  final TextEditingController _portsController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  void sendScanRequest() async {
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

    final Map<String, dynamic> requestData = {
      "uid": 10101,
      "request_time": formattedDateTime,
      "hosts": targets.split(','),
      "ports": ports,
      "speed": speed,
    };
    final Uri url = Uri.parse("http://192.168.20.140:8080/scan");
    print(requestData);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запрос успешно отправлен!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось отправить запрос: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MtOpenDialogButton(
      dialogueTitle: 'Новое сканирование',
      buttonTitle: 'Сканировать',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _targetsController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Цели сканирования'),
              readOnly: false,
            ),
            TextField(
              controller: _portsController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Порты(через запятую)'),
              readOnly: false,
            ),
            TextField(
              controller: _speedController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Скорость сканирования (1-5)'),
              readOnly: false,
            ),
            OutlinedButton(
              style: const ButtonStyle(),
              onPressed: sendScanRequest,
              child:  Text(
                'Запустить сканирование',
                style: AppTheme.lightTheme.textTheme.labelSmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}
