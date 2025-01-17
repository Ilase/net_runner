
part of 'web_socket_bloc.dart';

abstract class WebSocketState extends Equatable {
  const WebSocketState();

  @override
  List<Object> get props => [];
}

class WebSocketInitial extends WebSocketState {}

class WebSocketConnecting extends WebSocketState {}

class WebSocketConnected extends WebSocketState {}

class WebSocketDisconnected extends WebSocketState {}

class WebSocketMessage extends WebSocketState {
  final String message;

  const WebSocketMessage(this.message);

  @override
  List<Object> get props => [message];
}

class WebSocketMessageSent extends WebSocketState {
  final String message;

  const WebSocketMessageSent(this.message);

  @override
  List<Object> get props => [message];
}

class WebSocketErrorState extends WebSocketState {
  final String error;

  const WebSocketErrorState(this.error);

  @override
  List<Object> get props => [error];
}