part of 'web_socket_bloc.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WebSocketConnect extends WebSocketEvent {
  final String url;
  const WebSocketConnect(this.url);

  @override
  List<Object> get props => [url];
}

class WebSocketDisconnect extends WebSocketEvent{}

class WebSocketSendMessage extends WebSocketEvent{
  final String message;
  const WebSocketSendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class WebSocketMessageReceived extends WebSocketEvent{
  final List<Map<String, dynamic>> message;

  const WebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}



