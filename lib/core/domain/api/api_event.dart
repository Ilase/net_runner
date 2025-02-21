part of 'api_bloc.dart';

abstract class ApiEvent {}

class ConnectToServerEvent extends ApiEvent {
  final ApiEndpoints endpoints;
  ConnectToServerEvent({required this.endpoints});
}

class GetGroupListEvent extends ApiEvent {}

class FetchTaskListEvent extends ApiEvent {}

class GetPentestReportEvent extends ApiEvent {
  final String taskName;

  ///TODO: Rewrite to TASK ID;
  GetPentestReportEvent({required this.taskName});
}

class ClosePentestReportEvent extends ApiEvent {}

class GetHostListEvent extends ApiEvent {}

class GetPingListEvent extends ApiEvent {}

class GetReport extends ApiEvent {
  final String task_number;
  GetReport({required this.task_number});
}
