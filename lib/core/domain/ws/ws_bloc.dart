import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'ws_event.dart';
part 'ws_state.dart';

class WsBloc extends Bloc<WsEvent, WsState> {
  Map<String, dynamic> headers;
  late WebSocketChannel channel;
  WsBloc({
    required this.headers,
  }) : super(WsInitial()) {
    on<WsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
