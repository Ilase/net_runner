import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:net_runner/core/data/task_controller.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';
import 'package:web_socket_channel/io.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  static String uri = "";
  // TaskController taskController = TaskController();
  final ElementBloc elementBloc;
  late IOWebSocketChannel channel;
  StreamSubscription? _subscription;

  WebSocketBloc(this.elementBloc) : super(WebSocketInitial()) {
    on<WebSocketConnect>(_connectToWs);
    on<WebSocketDisconnect>(_disconnectWs);



    on<WebSocketMessageReceived>((event, emit) {
      emit(WebSocketMessageState(event.message));
    });


  }

  Future<void> _disconnectWs(WebSocketDisconnect event, Emitter emit) async {
    _subscription?.cancel();
    channel.sink.close();
    emit(WebSocketDisconnected());
  }

  Future<void> _connectToWs(WebSocketConnect event, Emitter emit) async {
    try{
      channel = IOWebSocketChannel.connect(
        event.url,
      );
      print(event.url);
      _subscription = channel.stream.listen((message) async {
        if(message.isEmpty){
          print("Message empty");
        } else {
          print('Message not empty');
        }
        print(event.url);
        print('Message received: $message');

        //if(emit.isDone) return;

        try{
          final Map<String,dynamic> decodedMessage = jsonDecode(message);
          //print("decoded mes" + decodedMessage.toString());

          if (!emit.isDone) {
            emit(WebSocketMessageState(decodedMessage));
          }
          elementBloc.add(AddOrUpdateElement(decodedMessage));

        } catch(e){
          print('Ошибка обработки сообщения: $e*');
        }





      });

      emit(WebSocketConnected());
    } catch(e){
      print(e);
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
