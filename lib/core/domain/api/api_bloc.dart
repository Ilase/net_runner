import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/api/ping_list/ping_list_cubit.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  PingListCubit pingList = PingListCubit();
  HostListCubit hostList = HostListCubit();

  ApiBloc() : super(ApiInitial()) {
    on<GetHosts>(_getHostList);
  }

  Future<void> _getHostList(GetHosts event, Emitter emit) async {
    final response =
        await http.get(Uri.parse("http://192.168.20.193:3002/api/v1/host"));
    //ntLogger.i(jsonDecode(response.body));
    if (response.statusCode == 200) {
      hostList.updateState(jsonDecode(response.body));
    } else {
      ntLogger.e("Cant add hosts to list");
    }
  }

  Future<void> _getPingList() async {}

  Future<void> _getGroupList() async {}

  Future<void> _postRequest() async {}
}
