// import 'package:http/http.dart' as http;
//
// class SendScanRequest{
//
//
//   void sendScanRequest() async {
//     final String targets = _targetsController.text;
//     final String ports = _portsController.text;
//     final String speed = _speedController.text;
//     if (targets.isEmpty || ports.isEmpty || speed.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(
//           'Пожалуйста, заполните все поля',
//           //style: AppTheme.lightTheme.textTheme.titleLarge,
//         )),
//       );
//       return;
//     }
//     final DateTime now = DateTime.now();
//     final String formattedDateTime =
//         "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
//
//     final Map<String, dynamic> requestData = {
//       "uid": 10101,
//       "request_time": formattedDateTime,
//       "hosts": targets.split(','),
//       "ports": ports,
//       "speed": speed,
//     };
//     final Uri url = Uri.parse("http://192.168.20.140:8080/scan");
//     print(requestData);
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestData),
//       );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Запрос успешно отправлен!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Ошибка: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Не удалось отправить запрос: $e')),
//       );
//     }
//   }
// }