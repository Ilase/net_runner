import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/api_endpoints.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  late ApiEndpoints apiEndpoints;
  HostListCubit hostListCubit;
  GroupListCubit groupListCubit;
  TaskListCubit taskListCubit;

  ///
  late WebSocketChannel webSocketChannel;
  StreamSubscription? _webSocketSubscription;

  ///
  //static const Map<String, dynamic> apiEndpoints = {};
  ApiBloc({
    required this.hostListCubit,
    required this.groupListCubit,
    required this.taskListCubit,
  }) : super(ApiInitial()) {
    on<ConnectToServerEvent>(_connectToServer);
    on<GetGroupListEvent>(_getGroupList);
    on<FetchTaskListEvent>(_fetchTasKListEvent);
  }

  Future<void> _connectToServer(
    ConnectToServerEvent event,
    Emitter emit,
  ) async {
    apiEndpoints = event.endpoints;
    emit(ConnectLoadState()); // Отправка стейта загрузки
    bool isConnected = await _checkConnectionToServer();
    if (isConnected) {
      try {
        webSocketChannel = WebSocketChannel.connect(apiEndpoints.getUri("ws"));
        _webSocketSubscription = webSocketChannel.stream.listen(
          (message) async {
            try {
              final Map<String, dynamic> decodedMessage = jsonDecode(message);
              ntLogger.w('Message from web socket: \n $decodedMessage');
              taskListCubit.updateElementInTaskList(decodedMessage);
            } catch (e) {} //add error stack
          },
        );
        emit(ConnectedState());
      } catch (e) {
        ntLogger.e(e.toString());
      }

      // Отправка стейта удачного подключения
    } else {
      emit(ConnectErrorState()); // Отправка стейта ошибки подключения
    }
  }

  Future<void> _fetchTasKListEvent(
      FetchTaskListEvent event, Emitter emit) async {
    final response = await http.get(apiEndpoints.getUri("get-task-list"));
    if (response.statusCode == 200) {
      taskListCubit.fillTaskListFromGet(jsonDecode(response.body));
    }

    /// TODO: add handler cubit
  }

  /// Функция для проверки подключения к серверу
  /// return bool true | false
  Future<bool> _checkConnectionToServer() async {
    final response = await http.get(apiEndpoints.getUri("check-connection"));
    if (response.statusCode == 200 &&
        jsonDecode(response.body)["netrunnerStatus"] == "up") {
      return true;
    }
    return false;
  }

  Future<void> _connectToWs() async {}

  /// Функция для обновления листа стейта в ApiListCubit и проверки ответа от сервера
  /// GET .../host
  Future<void> _getHostList(GetGroupListEvent event, Emitter emit) async {
    final response = await http.get(apiEndpoints.getUri("get-host-list"));
    if (response.statusCode == 200) {
      List hostList = jsonDecode(response.body);

      /// Обновление списка
      // hostListCubit.updateState({"hostList": hostList});
    } else {
      ntLogger.e('Error occured while parsing data');
    }
  }

  /// Dead-code
  // Future<void> _getTaskList() async {
  //   final response = await http.get(apiEndpoints.getUri("get-task-list"));
  //
  //   if (response.statusCode == 200) {
  //     /// Обновление списка
  //     //apiListCubit.updateState({"taskList": jsonDecode(response.body)});
  //   }
  // }

  Future<void> _getGroupList(GetGroupListEvent event, Emitter emit) async {
    final response = await http.get(apiEndpoints.getUri("get-group-list"));
    if (response.statusCode == 200) {
      List groupList = jsonDecode(response.body);

      /// Обновление списка
      groupListCubit.updateState({"groupList": groupList});
    } else {
      ntLogger.e('Error occurred while parsing data');
    }
  }
}
