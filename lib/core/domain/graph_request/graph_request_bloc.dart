import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/data/base_url.dart';
import 'package:net_runner/core/domain/api_data_controller/api_request.dart';

part 'graph_request_event.dart';
part 'graph_request_state.dart';

class GraphRequestBloc extends Bloc<GraphRequestEvent, GraphRequestState> {
  GraphRequestBloc() : super(GraphRequestInitial()) {
    on<GraphRequestGetNetwork>(_getNetwork);
  }


  Future<void> _getNetwork(GraphRequestGetNetwork event, Emitter emit) async {
    emit(GraphRequestInProgress());

    final response = await http.get(Uri.parse('http://$baseUrl${Api.api}${Api.stringVersion}/${Api.taskType["networkscan"]}/${event.taskName}'));
    if(response.statusCode == 200){
      emit(GraphRequestSuccess(graphJson: jsonDecode(response.body)));
    } else {
      emit(GraphRequestFailure(error: ''));
    }
  }
}
