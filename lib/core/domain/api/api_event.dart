part of 'api_bloc.dart';

abstract class ApiEvent {}

class ConnectToServerEvent extends ApiEvent {
  final ApiEndpoints endpoints;
  ConnectToServerEvent({required this.endpoints});
}

class DisconnectFromServerEvent extends ApiEvent {}

class GetGroupListEvent extends ApiEvent {}

class FetchTaskListEvent extends ApiEvent {
  final Map<String, String>? queryParams;
  FetchTaskListEvent({this.queryParams});
}

class GetPentestReportEvent extends ApiEvent {
  final String taskName;

  ///TODO: Rewrite to TASK ID;
  GetPentestReportEvent({required this.taskName});
}

class ClosePentestReportEvent extends ApiEvent {}

class GetHostListEvent extends ApiEvent {}

class GetPingListEvent extends ApiEvent {}

class GetReport extends ApiEvent {
  final String task_type;
  final String task_number;
  GetReport({required this.task_number, required this.task_type});
}

class PostTask extends ApiEvent {
  final Map<String, dynamic> body;
  final String type;
  PostTask({required this.body, required this.type});
}

class EditHost extends ApiEvent {
  final taskId;
  final Map<String, dynamic> body;
  EditHost({required this.taskId, required this.body});
}

class PostHost extends ApiEvent {
  final Map<String, dynamic> body;
  PostHost({required this.body});
}

class DownloadPdf extends ApiEvent {
  final String type;
  final String taskNumber;
  DownloadPdf({required this.taskNumber, required this.type});
}

class OpenReportInBrowser extends ApiEvent {
  final String task_number;
  final String type;
  OpenReportInBrowser({required this.task_number, required this.type});
}

class DeleteHost extends ApiEvent {
  final int id;
  DeleteHost({required this.id});
}

class DeleteGroup extends ApiEvent {
  final int id;
  DeleteGroup({required this.id});
}
