import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'api_data_controller_event.dart';
part 'api_data_controller_state.dart';

class ApiDataControllerBloc extends Bloc<ApiDataControllerEvent, ApiDataControllerState> {
  List<dynamic>? hostList;
  List<Map<String,dynamic>>? taskList;
  Map<String,dynamic>? hostPingList;
  ApiDataControllerBloc() : super(ApiDataControllerInitial()) {
    on<ApiDataControllerEvent>;
  }
}
