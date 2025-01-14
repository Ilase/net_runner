import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
part 'ws_event.dart';
part 'ws_state.dart';

class WsBloc extends Bloc<WsEvent, WsState> {
  socket_io.Socket? socket;
  Map<String,dynamic> headers;
  late final WebSocketChannel channel;
  StreamSubscription? _subscription;
  WsBloc({
    required this.headers,
  }) : super(WsInitial()) {
    on<WsConnectEvent>(_wsConnectEvent);
    on<WsDisconnectEvent>(_wsDisconnectEvent);
    on<WsSendJSEvent>(_wsSendJSEvent);
    on<WsReceiveJSEvent>(_wsReceiveJSEvent);
  }
  Future<void> _wsDisconnectEvent(WsDisconnectEvent event, Emitter emit) async {
    channel.sink.close();
  }
  Future<void> _wsConnectEvent(WsConnectEvent event, Emitter emit) async {
    channel = IOWebSocketChannel.connect(
      event.url,
      headers: event.headers
    );
    headers = event.headers;
    _subscription = channel.stream.listen(
        (message){
          add(WsReceiveJSEvent(message));
    });
    emit(WsConnected());
  }

  Future<void> _wsSendJSEvent(WsSendJSEvent event, Emitter emit) async {
    channel.sink.add(event.sendData);
  }
  Future<void> _wsReceiveJSEvent(WsReceiveJSEvent event, Emitter emit) async {
    emit(WsReceiveJSEvent(event.receivedData));
  }
  @override
  Future<void> close() {
    channel.sink.close();
    return super.close();
  }
}
