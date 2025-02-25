import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/data/task_report_serial/pentest_report_serial.dart';
import 'package:net_runner/core/domain/api/api_endpoints.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/notificatioon_controller/notification_controller_cubit.dart';
import 'package:net_runner/core/domain/pentest_report_controller/pentest_report_controller_cubit.dart';
import 'package:net_runner/core/domain/ping_list/ping_list_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  late ApiEndpoints apiEndpoints;
  HostListCubit hostListCubit;
  GroupListCubit groupListCubit;
  TaskListCubit taskListCubit;
  PingListCubit pingListCubit;
  NotificationControllerCubit notificationControllerCubit;
  PentestReportControllerCubit pentestReportControllerCubit;

  ///
  late WebSocketChannel webSocketChannel;
  StreamSubscription? _webSocketSubscription;

  ///
  //static const Map<String, dynamic> apiEndpoints = {};
  ApiBloc({
    required this.hostListCubit,
    required this.groupListCubit,
    required this.taskListCubit,
    required this.pingListCubit,
    required this.notificationControllerCubit,
    required this.pentestReportControllerCubit,
  }) : super(ApiInitial()) {
    on<ConnectToServerEvent>(_connectToServer);
    on<GetGroupListEvent>(_getGroupList);
    on<FetchTaskListEvent>(_fetchTasKListEvent);
    on<GetHostListEvent>(_getHostList);
    on<GetPingListEvent>(_getPingList);
    on<GetReport>(_getReport);
  }

  Future<void> _connectToServer(
    ConnectToServerEvent event,
    Emitter emit,
  ) async {
    try {
      apiEndpoints = event.endpoints;
      emit(ConnectLoadState());
      bool isConnected = await _checkConnectionToServer();
      if (isConnected) {
        try {
          webSocketChannel =
              WebSocketChannel.connect(apiEndpoints.getUri("ws"));
          _webSocketSubscription = webSocketChannel.stream.listen(
            (message) async {
              try {
                final Map<String, dynamic> decodedMessage = jsonDecode(message);
                ntLogger.w('Message from web socket: \n $decodedMessage');
                taskListCubit.updateElementInTaskList(decodedMessage);
              } catch (e) {
                notificationControllerCubit.addNotification(
                    "Ошибка подключения",
                    "Подключение к серверу завершилось ошибкой: ${e.toString()}");
              } //add error stack
            },
          );
          notificationControllerCubit.addNotification("Подключено", "");
          emit(ConnectedState());
        } catch (e) {
          notificationControllerCubit.addNotification("Ошибка подключения",
              "Подключение к серверу завершилось ошибкой: ${e.toString()}");
        }
      }
    } catch (e) {
      notificationControllerCubit.addNotification("Ошибка подключения",
          "Подключение к серверу завершилось ошибкой: ${e.toString()}");
    }
  }

  Future<void> _fetchTasKListEvent(
      FetchTaskListEvent event, Emitter emit) async {
    // Показывает индикатор загрузки перед обновлением
    taskListCubit.clearList(); // Очистить список перед запросом

    final response = await http.get(apiEndpoints.getUri("get-task-list"));
    ntLogger.t(response.body);
    if (response.statusCode == 200) {
      taskListCubit.fillTaskListFromGet(jsonDecode(response.body));
    }
  }

  /// Функция для проверки подключения к серверу
  /// return bool true | false
  Future<bool> _checkConnectionToServer() async {
    final response = await http.get(apiEndpoints.getUri("check-connection"));
    if (response.statusCode == 200 &&
        jsonDecode(response.body)["netrunnerStatus"] == "up") {
      return true;
    }
    notificationControllerCubit.addNotification(
        "Ошибка данных", "Статус: ${response.statusCode}. ${response.body}");
    return false;
  }

  /// Функция для обновления листа стейта в ApiListCubit и проверки ответа от сервера
  /// GET .../host

  Future<void> _getHostList(GetHostListEvent event, Emitter emit) async {
    final response = await http.get(apiEndpoints.getUri("get-host-list"));

    if (response.statusCode == 200) {
      hostListCubit.updateState({"hostList": jsonDecode(response.body)});
      return;
    }
    notificationControllerCubit.addNotification(
        "Ошибка данных", "Статус: ${response.statusCode}. ${response.body}");
    return;
  }

  Future<void> _getGroupList(GetGroupListEvent event, Emitter emit) async {
    final response = await http.get(apiEndpoints.getUri("get-group-list"));
    if (response.statusCode == 200) {
      List groupList = jsonDecode(response.body);

      /// Обновление списка
      groupListCubit.updateState({"groupList": groupList});
    } else {
      notificationControllerCubit.addNotification(
          "Ошибка данных", "Статус: ${response.statusCode}. ${response.body}");
    }
  }

  Future<void> _getPingList(GetPingListEvent event, Emitter emit) async {
    final response = await http.get(apiEndpoints.getUri("get-ping-list"));
    ntLogger.i(response.body);
    if (response.statusCode == 200) {
      pingListCubit.updateState(jsonDecode(response.body));
    } else {
      notificationControllerCubit.addNotification(
          "Ошибка данных", "Статус: ${response.statusCode}. ${response.body}");
    }
  }

  Future<void> _getReport(GetReport event, Emitter emit) async {
    ntLogger.t(apiEndpoints
        .getUri("get-task-list", extraPaths: [event.task_number]).path);
    final response = await http.get(
        apiEndpoints.getUri("pentest-report", extraPaths: [event.task_number]));
    if (response.statusCode == 200) {
      pentestReportControllerCubit.getTask(jsonDecode(response.body));
    } else {
      notificationControllerCubit.addNotification(
          "Ошибка данных", "Статус: ${response.statusCode}. ${response.body}");
    }
  }
}
