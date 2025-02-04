import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  static String uri = "";
  // TaskController taskController = TaskController();
  final ElementBloc elementBloc;
  late WebSocketChannel channel;
  StreamSubscription? _subscription;

  WebSocketBloc(this.elementBloc) : super(WebSocketInitial()) {
    on<WebSocketConnect>(_connectToWs);
    on<WebSocketDisconnect>(_disconnectWs);
    // on<WebSocketMessageReceived>((event, emit) {
    //   emit(WebSocketMessageState(event.message));
    // });
  }

  Future<void> _disconnectWs(WebSocketDisconnect event, Emitter emit) async {
    _subscription?.cancel();
    channel.sink.close();
    emit(WebSocketDisconnected());
  }
  Future<void> _connectToWs(WebSocketConnect event, Emitter emit) async {
    try{
      channel = WebSocketChannel.connect(
        Uri.parse(event.url),
      );
      ntLogger.i(event.url);
      _subscription = channel.stream.listen((message) async {
        if(message.isEmpty){
          ntLogger.w("Message empty");
        } else {
          ntLogger.w('Message not empty');
        }
        ntLogger.i(event.url);
        ntLogger.i('Message received: $message');

        try{
          final Map<String,dynamic> decodedMessage = jsonDecode(message);

          if (!emit.isDone) {
            emit(WebSocketMessageState(decodedMessage));
          }
          elementBloc.add(AddOrUpdateElement(decodedMessage));

        } catch(e){
          ntLogger.e('Ошибка обработки сообщения: $e*');
          emit(WebSocketError(e.toString()));
        }
      });
      emit(WebSocketConnected());
    } catch(e){
      ntLogger.e(e);
      emit(WebSocketError(e.toString()));
    }
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
