import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/io.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final String uid = "";
  final String token = "";
  late IOWebSocketChannel channel;
  StreamSubscription? _subscription;

  WebSocketBloc() : super(WebSocketInitial()) {
    on<WebSocketConnect>((event, emit) {
      channel = IOWebSocketChannel.connect(event.url,
      headers: {
        "uid": uid,
        "token": token
        // "uid":"1378500800859113",
        // "token":"3045022100f9e2e5e01ac12458f7c1f7753d1584a3527fc1d17df0466baf61e3de4a61a2c5022009bfe43ac628ac4d0ff55c2098dee5332c64dfbf5b90f500665988f46e87abef"
      });
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
