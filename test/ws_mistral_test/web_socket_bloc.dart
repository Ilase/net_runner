import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final String url;
  final Map<String, dynamic> headers;
  WebSocketChannel? _channel;

  WebSocketBloc(this.url, this.headers) : super(WebSocketInitial()) {
    on<WebSocketConnect>(_connect);
    on<WebSocketDisconnect>(_disconnect);
    on<WebSocketMessageReceived>(_receiveMessage);
    on<WebSocketSendMessage>(_sendMessage);
    on<WebSocketError>(_errorState);
  }

  Future<void> _connect(WebSocketConnect event, Emitter emit) async {
    try {
      emit(WebSocketConnecting());
      _channel = IOWebSocketChannel.connect(
          url,
          headers: headers);
      _channel!.stream.listen(
            (message) {
          add(WebSocketMessageReceived(message));
        },
        onError: (error) {
          add(WebSocketError(error.toString()));
        },
        onDone: () {
          add(WebSocketDisconnect());
        },
      );
      emit(WebSocketConnected());
    } catch (e) {
      emit(WebSocketErrorState(e.toString()));
    }
  }
  Future<void> _disconnect(WebSocketDisconnect event, Emitter emit) async {
    _channel?.sink.close();
    emit(WebSocketDisconnected());
  }
  Future<void> _receiveMessage(WebSocketMessageReceived event, Emitter emit) async {
    emit(WebSocketMessage(event.message));
  }
  Future<void> _sendMessage(WebSocketSendMessage event, Emitter emit) async {
    _channel?.sink.add(event.message);
    emit(WebSocketMessageSent(event.message));
  }
  Future<void> _errorState(WebSocketError event, Emitter emit) async {
    emit(WebSocketErrorState(event.error));
  }


  @override
  Future<void> close() {
    _channel?.sink.close();
    return super.close();
  }
}



// {
// "uid" : "1378500800859113",
// "token":"3045022100f9e2e5e01ac12458f7c1f7753d1584a3527fc1d17df0466baf61e3de4a61a2c5022009bfe43ac628ac4d0ff55c2098dee5332c64dfbf5b90f500665988f46e87abef"
// }