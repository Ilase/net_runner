part of 'web_socket_bloc.dart';

abstract class WebSocketState extends Equatable {
  const WebSocketState();

  @override
  List<Object?> get props => [];
}

final class WebSocketInitial extends WebSocketState {}
final class WebSocketConnected extends WebSocketState {}
final class WebSocketDisconnected extends WebSocketState {}
final class WebSocketMessageState extends WebSocketState {
  final String message;

  const WebSocketMessageState(this.message);
  @override
  List<Object> get props => [message];
}
