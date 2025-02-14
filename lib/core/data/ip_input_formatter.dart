import 'package:flutter/services.dart';

class IPTextInputFormatter extends TextInputFormatter {
  final bool _allowPort;

  IPTextInputFormatter() : _allowPort = false;
  IPTextInputFormatter.withPort() : _allowPort = true;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    // Разрешаем ввод двоеточия, но валидируем IP и порт
    String ipPart = text;
    String? portPart;

    if (_allowPort && text.contains(':')) {
      List<String> parts = text.split(':');
      if (parts.length > 2) return oldValue; // Больше одного ":" — некорректный ввод

      ipPart = parts[0];
      portPart = parts.length == 2 ? parts[1] : null;
    }

    // Проверяем корректность IP-адреса
    List<String> octets = ipPart.split('.');
    if (octets.length > 4) return oldValue; // IP не может содержать более 4 частей

    for (String octet in octets) {
      if (octet.isNotEmpty) {
        if (!RegExp(r'^\d+$').hasMatch(octet)) return oldValue; // Только цифры
        int num = int.parse(octet);
        if (num > 255) return oldValue;
      }
    }

    // Проверяем корректность порта
    if (portPart != null) {
      if (portPart.isNotEmpty && !RegExp(r'^\d+$').hasMatch(portPart)) {
        return oldValue; // Только цифры в порте
      }
      if (portPart.isNotEmpty) {
        int? portNum = int.tryParse(portPart);
        if (portNum == null || portNum < 1 || portNum > 65535) {
          return oldValue;
        }
      }
    }

    return newValue;
  }
}
