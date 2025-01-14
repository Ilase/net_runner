part of 'ws_bloc.dart';


abstract class WsState {}

class WsInitial extends WsState {
  WsInitial();
}
class WsConnected extends WsState {}
class WsDisconnected extends WsState {}
class WsError extends WsState {}
class WsJSMessage extends WsState {
  final Map<String, dynamic> message;
  WsJSMessage(this.message);
}
