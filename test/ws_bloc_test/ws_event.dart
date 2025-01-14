part of 'ws_bloc.dart';


abstract class WsEvent {}

class WsConnectEvent extends WsEvent {
  final String url;
  final Map<String, dynamic> headers;
  WsConnectEvent({required this.url, required this.headers});

}
class WsDisconnectEvent extends WsEvent {}

class WsSendJSEvent extends WsEvent {
  final Map<String, dynamic> sendData;
  WsSendJSEvent({required this.sendData});
}
class WsReceiveJSEvent extends WsEvent {
  final Map<String, dynamic> receivedData;
  WsReceiveJSEvent(this.receivedData);
}