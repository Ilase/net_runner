import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  late IOWebSocketChannel channel;
  StreamSubscription? _subscription;

  WebSocketBloc() : super(WebSocketInitial()) {
    on<WebSocketConnect>((event, emit) {
      channel = IOWebSocketChannel.connect(event.url);
      _subscription = channel.stream.listen((message) {
        add(WebSocketMessageReceived(message));
      });
      emit(WebSocketConnected());
    });
    on<WebSocketSendMessage>((event, emit) {
      channel.sink.add(event.message);
    });

    on<WebSocketMessageReceived>((event, emit) {
      emit(WebSocketMessageState(event.message));
    });
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
