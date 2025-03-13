import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/data/platform.dart';
import 'package:net_runner/core/domain/api/api_endpoints.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/notificatioon_controller/notification_controller_cubit.dart';
import 'package:net_runner/core/domain/pentest_report_controller/pentest_report_controller_cubit.dart';
import 'package:net_runner/core/domain/ping_list/ping_list_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:net_runner/core/domain/user_repository/user_data_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  String? token =
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDEyNTY5MDIsInJvbGUiOiJhZG1pbiIsInVzZXJuYW1lIjoiSWxhc2UifQ.ryqB-SqYYJw1rRIPQX1zhgkB7G8YQc83KFlpp3ylzak";
  Map<String, String> headers = {"Authorization": ""};
  late ApiEndpoints apiEndpoints;
  HostListCubit hostListCubit;
  GroupListCubit groupListCubit;
  TaskListCubit taskListCubit;
  PingListCubit pingListCubit;
  NotificationControllerCubit notificationControllerCubit;
  ReportControllerCubit reportControllerCubit;
  UserDataCubit userDataCubit;

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
    required this.reportControllerCubit,
    required this.userDataCubit,
  }) : super(ApiInitial()) {
    on<ConnectToServerEvent>(_connectToServer);
    on<DisconnectFromServerEvent>(_disconnectFromServer);
    on<LoginToServer>(_loginToServer);
    on<GetGroupListEvent>(_getGroupList);
    on<FetchTaskListEvent>(_fetchTasKListEvent);
    on<GetHostListEvent>(_getHostList);
    on<GetPingListEvent>(_getPingList);
    on<GetReport>(_getReport);
    on<PostTask>(_postTask);
    on<PostGroup>(_postGroup);
    on<EditHost>(_editHost);
    on<PostHost>(_postHost);
    on<DownloadPdf>(_downloadReportPdf);
    on<OpenReportInBrowser>(_openTaskInBrowser);
    on<DeleteGroup>(_deleteGroup);
    on<DeleteHost>(_deleteHost);
    on<PutHost>(_putHost);
  }

  Future<void> _loginWithWsConnect() async {}

  Future<void> _connectToServer(
    ConnectToServerEvent event,
    Emitter emit,
  ) async {
    try {
      apiEndpoints = event.endpoints;
      emit(ConnectLoadState());
      bool isConnected = await _checkConnectionToServer();
      if (isConnected) {
        // try {
        //   webSocketChannel = IOWebSocketChannel.connect(
        //     apiEndpoints.getUri("ws"),
        //     headers: {
        //       "Sec-WebSocket-Protocol": headers["Authorization"],
        //     },
        //   );
        //   _webSocketSubscription = webSocketChannel.stream.listen(
        //     (message) async {
        //       try {
        //         final Map<String, dynamic> decodedMessage = jsonDecode(message);
        //         ntLogger.w('Message from web socket: \n $decodedMessage');
        //         final ModelTask newElement = ModelTask.fromJson(decodedMessage);
        //         taskListCubit.updateElementInTaskList(newElement);
        //       } catch (e) {
        //         notificationControllerCubit.addNotification(
        //             "Ошибка подключения",
        //             "Подключение к серверу завершилось ошибкой: ${e.toString()}",
        //             NotificationType.error);
        //       } //add error stack
        //     },
        //   );
        //   notificationControllerCubit.addNotification(
        //       "Подключено", "", NotificationType.success);
        //   emit(ConnectedState());
        // } catch (e) {
        //   notificationControllerCubit.addNotification(
        //       "Ошибка подключения",
        //       "Подключение к серверу завершилось ошибкой: ${e.toString()}",
        //       NotificationType.error);
        // }
        notificationControllerCubit.addNotification(
            "Успешно", "Сервер определён", NotificationType.success);
        emit(ConnectedToServerState());
      }
    } catch (e) {
      notificationControllerCubit.addNotification(
          "Ошибка подключения",
          "Подключение к серверу завершилось ошибкой: ${e.toString()}",
          NotificationType.error);
    }
  }

  Future<void> _disconnectFromServer(
      DisconnectFromServerEvent event, Emitter emit) async {
    if (_webSocketSubscription != null) {
      await _webSocketSubscription?.cancel();
      _webSocketSubscription = null;
    }

    if (webSocketChannel.sink != null) {
      await webSocketChannel.sink.close();
    }

    if (apiEndpoints.getUri("check-connection") != null) {
      apiEndpoints = ApiEndpoints(host: "", port: 0, scheme: "");
      notificationControllerCubit.addNotification(
          "Отключено", "Вы отключены от сервера", NotificationType.success);
    }

    // notificationControllerCubit.clearNotifications();
    // _webSocketSubscription?.cancel();
    // webSocketChannel.sink.close();
    // apiEndpoints = ApiEndpoints(host: "", port: 0, scheme: "");
    // emit(DisconnectedState());
  }

  Future<void> _fetchTasKListEvent(
      FetchTaskListEvent event, Emitter emit) async {
    taskListCubit.clearList();

    final response = await http.get(
        apiEndpoints.getUri("get-task-list", queryParams: event.queryParams),
        headers: headers);
    ntLogger.t(response.body);
    if (response.statusCode == 200) {
      // Decode the JSON response into a List<dynamic>
      final List<dynamic> jsonList = jsonDecode(response.body);

      // Convert List<dynamic> to List<ModelTask>
      final List<ModelTask> tasks = jsonList
          .map((taskJson) =>
              ModelTask.fromJson(taskJson as Map<String, dynamic>))
          .toList();

      taskListCubit.fillTaskListFromGet(tasks);
    } else {
      ntLogger.e("Failed to fetch task list: ${response.statusCode}");
      notificationControllerCubit.addNotification(
        "Ошибка данных",
        "Статус: ${response.statusCode}. ${response.body}",
        NotificationType.error,
      );
    }
  }

  Future<void> _fetchNetworkScanTaskListEvent(
      FetchTaskListEvent event, Emitter emit) async {
    taskListCubit.clearList();

    final response = await http.get(
        apiEndpoints
            .getUri("get-task-list", queryParams: {"type": "networkscan"}),
        headers: headers);
    ntLogger.t(response.body);
    if (response.statusCode == 200) {
      // Decode the JSON response into a List<dynamic>
      final List<dynamic> jsonList = jsonDecode(response.body);

      // Convert List<dynamic> to List<ModelTask>
      final List<ModelTask> tasks = jsonList
          .map((taskJson) =>
              ModelTask.fromJson(taskJson as Map<String, dynamic>))
          .toList();

      taskListCubit.fillTaskListFromGet(tasks);
    } else {
      ntLogger.e("Failed to fetch task list: ${response.statusCode}");
      notificationControllerCubit.addNotification(
        "Ошибка данных",
        "Статус: ${response.statusCode}. ${response.body}",
        NotificationType.error,
      );
    }
  }

  /// Функция для проверки подключения к серверу
  /// return bool true | false
  Future<bool> _checkConnectionToServer() async {
    final response = await http.get(apiEndpoints.getUri("check-connection"),
        headers: headers);
    if (response.statusCode == 200 &&
        jsonDecode(response.body)["netrunnerStatus"] == "up") {
      return true;
    }
    notificationControllerCubit.addNotification(
        "Ошибка данных",
        "Статус: ${response.statusCode}. ${jsonDecode(response.body)["error"]}",
        NotificationType.error);
    return false;
  }

  /// Функция для обновления листа стейта в ApiListCubit и проверки ответа от сервера
  /// GET .../host

  Future<void> _getHostList(GetHostListEvent event, Emitter emit) async {
    final response =
        await http.get(apiEndpoints.getUri("get-host-list"), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<Map<String, dynamic>> jsonMapList =
          jsonList.cast<Map<String, dynamic>>();
      hostListCubit.updateState(jsonMapList);
      return;
    } else {
      notificationControllerCubit.addNotification(
          "Ошибка данных",
          "Статус: ${response.statusCode}. ${response.body}",
          NotificationType.error);
      return;
    }
  }

  Future<void> _getGroupList(GetGroupListEvent event, Emitter emit) async {
    final response =
        await http.get(apiEndpoints.getUri("get-group-list"), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<Map<String, dynamic>> groups =
          jsonList.cast<Map<String, dynamic>>();

      /// Обновление списка
      groupListCubit.updateState(groups);
    } else {
      notificationControllerCubit.addNotification(
          "Ошибка данных",
          "Статус: ${response.statusCode}. ${response.body}",
          NotificationType.error);
    }
  }

  Future<void> _getPingList(GetPingListEvent event, Emitter emit) async {
    final response =
        await http.get(apiEndpoints.getUri("get-ping-list"), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> pingList = jsonDecode(response.body)["activeHosts"];
      pingListCubit.updateState(pingList);
    } else {
      notificationControllerCubit.addNotification(
          "Ошибка данных",
          "Статус: ${response.statusCode}. ${response.body}",
          NotificationType.error);
    }
  }

  Future<void> _getReport(GetReport event, Emitter emit) async {
    final response = await http.get(
        apiEndpoints.getUri(event.task_type, extraPaths: [event.task_number]),
        headers: headers);
    if (response.statusCode == 200) {
      reportControllerCubit.getTask(jsonDecode(response.body), event.task_type);
    } else {
      reportControllerCubit.errorState();
      notificationControllerCubit.addNotification(
        "Ошибка данных",
        "Статус: ${response.statusCode}. ${jsonDecode(response.body)["err"]}",
        NotificationType.error,
      );
    }
  }

  Future<void> _postTask(PostTask event, Emitter emit) async {
    try {
      final response = await http.post(apiEndpoints.getUri("get-task-list"),
          body: jsonEncode(event.body), headers: headers);
      if (response.statusCode == 200) {
        int taskId = jsonDecode(response.body)["task_id"];
        notificationControllerCubit.addNotification(
            "Успешно", "Задача $taskId создана.", NotificationType.success);
        return;
      } else {
        ntLogger.e(jsonDecode(response.body));
        notificationControllerCubit.addNotification("Ошибка заполниения",
            "Неправильно заполнены данные.", NotificationType.warning);
        return;
      }
    } catch (e) {
      notificationControllerCubit.addNotification(
          "Упс...", "Ошибка: ${e.toString()}", NotificationType.error);
      ntLogger.e(e.toString());
    }
  }

  Future<void> _editHost(EditHost event, Emitter emit) async {
    final response = await http.put(
        apiEndpoints.getUri(
          "get-host-list",
          extraPaths: ["${event.taskId}"],
        ),
        body: event.body,
        headers: headers);

    if (response.statusCode == 200) {
      int taskId = jsonDecode(response.body)["task_id"];
      notificationControllerCubit.addNotification(
          "Успешно", "Изменения применены", NotificationType.success);
      return;
    } else {
      notificationControllerCubit.addNotification(
          "Ошибка", "${jsonDecode(response.body)}", NotificationType.error);
      return;
    }
  }

  Future<void> _postHost(PostHost event, Emitter emit) async {
    final response = await http.post(apiEndpoints.getUri("get-host-list"),
        headers: headers, body: jsonEncode(event.body));

    if (response.statusCode == 201) {
      notificationControllerCubit.addNotification(
          "Создано", "Хост успешно создан", NotificationType.success);
      return;
    } else {
      notificationControllerCubit.addNotification("Ошибка создания",
          "${jsonDecode(response.body)["error"]}", NotificationType.error);

      return;
    }
  }

  Future<void> _downloadReportPdf(DownloadPdf event, Emitter emit) async {
    Dio dio = Dio(BaseOptions(headers: headers));

    if (!platform) {
      Directory? downloadDir;
      if (Platform.isLinux || Platform.isWindows) {
        downloadDir = await getDownloadsDirectory();
      } else {
        throw UnsupportedError("Поддерживаются только Windows и Linux");
      }

      if (downloadDir == null)
        throw Exception("Не удалось получить папку загрузок");

      String fileName = event.taskNumber;
      String savePath = '${downloadDir.path}/$fileName';
      try {
        await dio.download(
          apiEndpoints.getUri("check-connection",
              extraPaths: [event.type, event.taskNumber, "pdf"]).toString(),
          savePath,
        );
        _openFileExplorer(downloadDir.path);
        notificationControllerCubit.addNotification(
            "Успешно ",
            "Проверьте папку Загрузок на вышем устройстве",
            NotificationType.success);
      } catch (e) {
        ntLogger.e(e.toString());
      }
    } else {
      String fileName = event.taskNumber;

      final response = await dio.get(
        apiEndpoints.getUri(event.type,
            extraPaths: [event.taskNumber, "pdf"]).toString(),
        options: Options(responseType: ResponseType.bytes),
      );
      final blob = html.Blob([response.data], 'application/octet-stream');
      final anchor =
          html.AnchorElement(href: html.Url.createObjectUrlFromBlob(blob))
            ..setAttribute('download', fileName)
            ..click();
      html.Url.revokeObjectUrl(anchor.href!);
    }
  }

  void _openFileExplorer(String directoryPath) {
    if (Platform.isWindows) {
      Process.run('explorer', [directoryPath]); // Windows
    } else if (Platform.isLinux) {
      Process.run('xdg-open', [directoryPath]); // Linux
    }
  }

  Future<void> _openTaskInBrowser(
      OpenReportInBrowser event, Emitter emit) async {
    final Uri taskUri = apiEndpoints.getUri(
      "check-connection",
      extraPaths: [
        event.type,
        event.task_number,
        "html",
      ],
    );
    final webController = WebViewConfiguration(
      enableJavaScript: true,
      headers: headers,
    );
    // final _webController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..loadRequest(
    //     Uri.parse("https://example.com"),
    //     headers: {"Authorization": "Bearer YOUR_TOKEN"},
    //   );
    if (!await launchUrl(
      taskUri,
      webViewConfiguration: webController,
    )) {
      notificationControllerCubit.addNotification(
        "Ошибка",
        "Невозможно открыть отчёт",
        NotificationType.error,
      );
    }
  }

  Future<void> _deleteGroup(DeleteGroup event, Emitter emit) async {
    final response = await http.delete(
        apiEndpoints
            .getUri("get-group-list", extraPaths: [event.id.toString()]),
        headers: headers);
    if (response.statusCode == 200) {
      notificationControllerCubit.addNotification(
          "Удалено", " Успешно удалён", NotificationType.success);
      return;
    } else {
      notificationControllerCubit.addNotification("Ошибка удаления",
          "${jsonDecode(response.body)}", NotificationType.error);
      return;
    }
  }

  Future<void> _deleteHost(DeleteHost event, Emitter emit) async {
    final response = await http.delete(
        apiEndpoints.getUri("get-host-list", extraPaths: [event.id.toString()]),
        headers: headers);
    if (response.statusCode == 200) {
      notificationControllerCubit.addNotification(
          "Удалено", " Успешно удалён", NotificationType.success);
      return;
    } else {
      notificationControllerCubit.addNotification("Ошибка удаления",
          "${jsonDecode(response.body)}", NotificationType.error);
      return;
    }
  }

  Future<void> _putHost(PutHost event, Emitter emit) async {
    final response = await http.put(
      apiEndpoints.getUri(
        "get-host-list",
        extraPaths: [
          event.hostId.toString(),
        ],
      ),
      body: jsonEncode(event.body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      notificationControllerCubit.addNotification(
          "Измененно", " Хост успешно изменён", NotificationType.success);
      return;
    } else {
      notificationControllerCubit.addNotification("Ошибка изменения",
          "${jsonDecode(response.body)}", NotificationType.error);
      return;
    }
  }

  Future<void> _loginToServer(LoginToServer event, Emitter emit) async {
    final response = await http.post(
      apiEndpoints.getUri("login"),
      body: jsonEncode({
        "login": event.login,
        "password": event.password,
      }),
    );
    if (response.statusCode == 200) {
      headers["Authorization"] = 'Bearer ' + jsonDecode(response.body)["token"];
      ntLogger.w(headers["Authorization"]);
      userDataCubit.login();

      try {
        webSocketChannel = IOWebSocketChannel.connect(
          apiEndpoints.getUri("ws"),
          headers: {
            "Sec-WebSocket-Protocol": headers["Authorization"],
          },
        );
        _webSocketSubscription = webSocketChannel.stream.listen(
          (message) async {
            try {
              final Map<String, dynamic> decodedMessage = jsonDecode(message);
              ntLogger.w('Message from web socket: \n $decodedMessage');
              final ModelTask newElement = ModelTask.fromJson(decodedMessage);
              taskListCubit.updateElementInTaskList(newElement);
            } catch (e) {
              notificationControllerCubit.addNotification(
                  "Ошибка подключения",
                  "Подключение к серверу завершилось ошибкой: ${e.toString()}",
                  NotificationType.error);
            } //add error stack
          },
        );
        notificationControllerCubit.addNotification(
            "Подключено", "", NotificationType.success);
        emit(ConnectedToServerState());
      } catch (e) {
        notificationControllerCubit.addNotification(
            "Ошибка подключения",
            "Подключение к серверу завершилось ошибкой: ${e.toString()}",
            NotificationType.error);
      }
    } else {
      ntLogger.e('Error login: ');
    }
  }

  Future<void> _postGroup(PostGroup event, Emitter emit) async {
    final response = await http.post(
        apiEndpoints.getUri(
          "get-group-list",
          extraPaths: [],
        ),
        headers: headers,
        body: jsonEncode(event.body));
    if (response.statusCode == 200) {
      notificationControllerCubit.addNotification(
          "Успешно", " Группа успешно создана", NotificationType.success);
      return;
    } else {
      print(response.body);
      print(response.statusCode);
      notificationControllerCubit.addNotification("Ошибка создания",
          "${jsonDecode(response.body)}", NotificationType.error);
      return;
    }
  }
}
