import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:net_runner/core/data/api_service/api_service.dart';
import 'package:net_runner/core/domain/api/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/api_data_controller/api_request.dart';
import 'package:net_runner/utils/constants/api_path.dart';

part 'api_data_controller_event.dart';
part 'api_data_controller_state.dart';

class ApiDataControllerBloc extends Bloc<ApiDataControllerEvent, ApiDataControllerState> {
  final ApiService apiService;
  final HostListCubit hostListCubit;

  // List<dynamic>? hostList;
  // List<Map<String,dynamic>>? taskList;
  // Map<String,dynamic>? hostPingList;
  ApiDataControllerBloc({
    required this.apiService,
    required this.hostListCubit,
  }) : super(ApiDataControllerInitial()) {
    on<GetRequestEvent>(_handleGetData);
  }


  Future<void> _handleGetData(GetRequestEvent event, Emitter emit) async {
    final response = await http.get(Uri.parse('http://192.168.20.193:3002/api/v1${event.endpoint}'));
    
    if(Api.apiRequest["get-host-list"]!  == event.endpoint /*&& response.statusCode == 200*/){
      hostListCubit.updateState(jsonDecode(response.body));
    }
  }
}
