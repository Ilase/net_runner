import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/domain/api/api_endpoints.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  late ApiEndpoints apiEndpoints;
  ApiListCubit apiListCubit;

  //static const Map<String, dynamic> apiEndpoints = {};
  ApiBloc({required this.apiListCubit}) : super(ApiInitial()) {
    on<ConnectToServerEvent>(_connectToServer);
  }

  Future<void> _connectToServer(ConnectToServerEvent event,
      Emitter emit,) async {
    apiEndpoints = event.endpoints;
    emit(ConnectLoadState()); // Отправка стейта загрузки
    bool isConnected = await _checkConnectionToServer();
    if (isConnected) {
      emit(ConnectedState()); // Отправка стейта удачного подключения


    } else {
      emit(ConnectErrorState()); // Отправка стейта ошибки подключения
    }
  }

  /// Функция для проверки подключения к серверу
  /// return bool true | false
  Future<bool> _checkConnectionToServer() async {
    final response = await http.get(apiEndpoints.getUri("check-connection"));
    if (response.statusCode == 200 &&
        jsonDecode(response.body)["netrunnerStatus"] == "up") {

      /// Обновление списка
      apiListCubit.updateState(
          jsonDecode(response.body)
      );

      return true;
    }
    return false;
  }

  /// Функция для обновления листа стейта в ApiListCubit и проверки ответа от сервера
  /// GET .../host
  Future<bool> _getHostList() async {
    final response = await http.get(apiEndpoints.getUri("get-host-list"));

    if (response.statusCode == 200) {
      List hostList = jsonDecode(response.body);

      /// Обновление списка
      apiListCubit.updateState({
        "hostList": hostList
      });

      return true;
    }
    return false;
  }

  Future<bool> _getTaskList() async {
    final response = await http.get(apiEndpoints.getUri("get-task-list"));

    if (response.statusCode == 200) {
      /// Обновление списка
      apiListCubit.updateState({
        "taskList": jsonDecode(response.body)
      });

      return true;
    }
    return false;
  }
}