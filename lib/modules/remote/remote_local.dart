import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteLocal {
  final String serverUrl;
  RemoteLocal(this.serverUrl);

  Future<http.Response> sendPostRequest(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$serverUrl/$endpoint');
    try {
      final responce = await http.post(url,
          headers: {'Content-Type': "application/json"},
          body: jsonEncode(data));
      if (responce.statusCode == 200 || responce.statusCode == 201) {
        print('Responce: ${responce.body}');
      } else {
        print('Error: ${responce.statusCode} - ${responce.body}');
      }
      return responce;
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }
}

Future<void> handleIncomingRequest(http.Request _request) async {
  if (_request.method == 'POST') {
    try {
      final requestData = jsonDecode(await _request.toString());
      // print
      final responceBody = {};
    } catch (e) {}
  }
}
