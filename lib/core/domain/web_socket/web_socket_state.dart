part of 'web_socket_bloc.dart';

abstract class WebSocketState extends Equatable {
  const WebSocketState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class WebSocketInitial extends WebSocketState {}
final class WebSocketConnected extends WebSocketState {
  // final List<Map<String,dynamic>> taskList;
  // const WebSocketConnected({required this.taskList});
}
final class WebSocketDisconnected extends WebSocketState {}
final class WebSocketMessageState extends WebSocketState {
  final message;

  const WebSocketMessageState(this.message);
  @override
  List<Object> get props => [message];
}
class WebSocketError extends WebSocketState {
  final String message;

  const WebSocketError(this.message);
  @override

  List<Object?> get props => [message];
}