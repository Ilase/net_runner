import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:net_runner/core/data/logger.dart';

part 'connection_init_event.dart';
part 'connection_init_state.dart';

class ConnectionInitBloc extends Bloc<ConnectionInitEvent, ConnectionInitState> {
  ConnectionInitBloc() : super(ConnectionInitInitial()) {
    on<ConnectionInitCheckEvent>(_checkConnection);
  }

  Future<void> _checkConnection(ConnectionInitCheckEvent event, Emitter emit) async {
    try{
      final response = await http.get(Uri.parse(event.uri));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)["netrunnerStatus"] == "up") {
          emit(ConnectionInitOk());
        }
      }
    } catch (e) {
      emit(ConnectionInitError(error: e.toString()));
      ntLogger.e('No netrunner services deployed on this URI!');
    }
  }
}
