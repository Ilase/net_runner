import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NETRUNNER Report',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReportScreen(),
    );
  }
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Map<String, dynamic>? generalInfo;
  List<dynamic>? details;

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/report.json');
    final jsonResponse = json.decode(jsonString);
    setState(() {
      generalInfo = jsonResponse['general_info'];
      details = jsonResponse['details'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NETRUNNER Report'),
      ),
      body: generalInfo == null || details == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Информация о сканировании',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Начало: ${generalInfo!['start']}'),
            Text('Завершение: ${generalInfo!['end']}'),
            Text('Версия NMap: ${generalInfo!['version']}'),
            Text('Время сканирования: ${generalInfo!['elapsed']} секунд'),
            Text('Активные хосты: ${generalInfo!['up']}'),
            Text('Неактивные хосты: ${generalInfo!['down']}'),
            Text('Всего хостов: ${generalInfo!['total']}'),
            SizedBox(height: 16),
            Text(
              'Детальная информация',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ExpansionTile(
              title: Text(
                'IP адреса с CVE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: _buildDetailsList(
                  details!.where((detail) => detail['cve'] != 'N/A').toList()),
            ),
            ExpansionTile(
              title: Text(
                'IP адреса с CVE равным N/A',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: _buildDetailsList(
                  details!.where((detail) => detail['cve'] == 'N/A').toList()),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailsList(List<dynamic> filteredDetails) {
    if (filteredDetails.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Нет данных'),
        )
      ];
    }

    return filteredDetails.map((detail) {
      return ListTile(
        title: Text('IP: ${detail['ip']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Port: ${detail['port']}'),
            Text('CVE: ${detail['cve']}'),
            if (detail.containsKey('description'))
              Text('Description: ${detail['description']}'),
          ],
        ),
      );
    }).toList();
  }
}
