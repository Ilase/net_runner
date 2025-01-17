import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;
import 'dart:io';
import 'package:xml/xml.dart';


void main() async {
  final result = await parseNmapXML('../assets/dart.xml');
  final data = result['data'] as List<List<String>>;
  final info = result['info'] as List<String>;

  print('Info: $info');
  for (var row in data) {
    print('IP: ${row[0]}, Port: ${row[1]}, CVE: ${row[2]}');
  }
}



Future<Map<String, dynamic>> parseNmapXML(String xmlFile) async {
  try {
    // Читаем XML-файл
    final file = File(xmlFile);
    final document = XmlDocument.parse(await file.readAsString());

    // Извлекаем общую информацию
    final nmapRun = document.rootElement;
    final startScan = nmapRun.getAttribute('startstr') ?? 'Unknown';
    final versionNmap = nmapRun.getAttribute('version') ?? 'Unknown';

    final finished = nmapRun
        .findAllElements('finished')
        .firstWhere((_) => true, orElse: () => XmlElement(xml.XmlName('')));
    final endScan = finished?.getAttribute('timestr') ?? 'Unknown';
    final elapsed = finished?.getAttribute('elapsed') ?? 'Unknown';
    final summary = finished?.getAttribute('summary') ?? 'Unknown';

    final hosts = nmapRun
        .findAllElements('hosts')
        .firstWhere((_) => true, orElse: () => XmlElement(xml.XmlName('')));
    final up = hosts?.getAttribute('up') ?? '0';
    final down = hosts?.getAttribute('down') ?? '0';
    final total = hosts?.getAttribute('total') ?? '0';

    final info = [
      startScan,
      endScan,
      versionNmap,
      elapsed,
      summary,
      up,
      down,
      total
    ];

    // Извлекаем данные по уязвимостям
    final data = <List<String>>[];
    for (final host in nmapRun.findAllElements('host')) {

      final address = host
          .findAllElements('address')
          .map((e) => e.getAttribute('addr') ?? 'Unknown')
          .firstWhere((_) => true, orElse: () => 'Unknown');

      for (final port in host.findAllElements('port')) {
        final portId = port.getAttribute('portid') ?? 'Unknown';
        var cveFound = false;

        for (final script in port.findAllElements('script')) {
          for (final table in script.findAllElements('table')) {
            final key = table.getAttribute('key') ?? '';
            if (key.startsWith('CVE')) {
              data.add([address, portId, key]);
              cveFound = true;
            }
          }
        }

        if (!cveFound) {
          data.add([address, portId, 'N/A']);
        }
      }
    }

    return {'data': data, 'info': info};
  } catch (e) {
    throw Exception('Ошибка обработки XML: $e');
  }
}