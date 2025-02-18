import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/domain/api/api_endpoints.dart';
part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  late ApiEndpoints apiEndpoints;
  //static const Map<String, dynamic> apiEndpoints = {};
  ApiBloc() : super(ApiInitial()) {
    on<ConnectToServerEvent>(_connectToServer);
  }

  Future<void> _connectToServer(
    ConnectToServerEvent event,
    Emitter emit,
  ) async {
    apiEndpoints = event.endpoints;
    bool isConnected = await _checkConnectionToServer();
    if (isConnected) {
      emit(ConnectedState());
    } else {
      emit(ConnectErrorState());
    }
  }

  Future<bool> _checkConnectionToServer() async {
    final response = await http.get(apiEndpoints.getUri("check-connection"));
    if (response.statusCode == 200 &&
        jsonDecode(response.body)["netrunnerStatus"] == "up") {
      return true;
    }
    return false;
  }
}
