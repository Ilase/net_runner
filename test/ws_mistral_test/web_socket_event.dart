part of 'web_socket_bloc.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();
  @override
  List<Object> get props => [];
}

class WebSocketConnect extends WebSocketEvent {}

class WebSocketDisconnect extends WebSocketEvent {}

class WebSocketMessageReceived extends WebSocketEvent {
  final String message;
  const WebSocketMessageReceived(this.message);
  @override
  List<Object> get props => [message];
}

class WebSocketSendMessage extends WebSocketEvent {
  final String message;
  const WebSocketSendMessage(this.message);
  @override
  List<Object> get props => [message];
}

class WebSocketSendRequest extends WebSocketEvent {
  final Map<String, dynamic> request;
  const WebSocketSendRequest(this.request);
}

class WebSocketError extends WebSocketEvent {
  final String error;
  const WebSocketError(this.error);
  @override
  List<Object> get props => [error];
}