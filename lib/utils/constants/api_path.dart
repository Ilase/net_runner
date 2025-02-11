import 'package:http/http.dart' as http;

class ApiEndpoints {
  static const String api = '/api/v1';
  static const String task = '/task';
  static const String host = '/host';
  static const String ping = '/ping';
}

class EndpointController {
  //String connectionType = 'http://';
  String serverIp;
  String serverPort;
  late String baseSocket;
  EndpointController({
    required this.serverIp,
    required this.serverPort,
  }){
    baseSocket = '$serverIp:$serverPort';
  }

  // Future<bool> checkConnection() async {
  //   final response = http.get(Uri.parse(
  //     getStringHttp()
  //   ));
  //   return false;
  // }
  // String getStringWs(){
  //   Uri result;
  //   result = Uri.parse('ws://$serverIp:$serverPort/${ApiEndpoints.api}');
  //
  //   return result;
  // }
  //
  // String getStringHttp(){
  //   Uri result;
  //   result = Uri.parse('http://$serverIp:$serverPort/${ApiEndpoints.api}');
  //
  //   return result;
  // }
}

