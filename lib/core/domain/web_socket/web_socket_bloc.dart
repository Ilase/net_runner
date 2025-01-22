import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:net_runner/core/data/task_controller.dart';
import 'package:web_socket_channel/io.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  TaskController taskController = TaskController();
  late IOWebSocketChannel channel;
  StreamSubscription? _subscription;

  WebSocketBloc() : super(WebSocketInitial()) {
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

      _subscription = channel.stream.listen((message) {
        if (message is String) {
          try {
            // Decode the message from JSON
            var decodedMessage = jsonDecode(message);

            // Ensure it's a list and cast to List<Map<String, dynamic>>
            if (decodedMessage is List) {
              var typedMessage = decodedMessage.cast<Map<String, dynamic>>();

              // Compare the existing dataList with the new message
              if (taskController.dataList != typedMessage) {
                taskController.resave(typedMessage);
              }

              // Emit the WebSocketMessageReceived event with the typedMessage
              add(WebSocketMessageReceived(typedMessage));
            } else {
              print('Unexpected message format: $message');
            }
          } catch (e) {
            print('Error decoding message: $e');
          }
        } else {
          print('Unexpected message type: $message');
        }
      });

      // _subscription = channel.stream.listen((message) {
      //
      //   if(taskController.dataList != message){
      //     taskController.resave(message);
      //   }
      //   add(WebSocketMessageReceived(message));
      // });

      emit(WebSocketConnected(taskList: this.taskController.dataList));
    } catch(e){
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
