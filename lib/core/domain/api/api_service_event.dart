part of 'api_service_bloc.dart';

@immutable
sealed class ApiServiceEvent {}

class FetchData extends ApiServiceEvent {
  final ApiRequestType requestType;
  final Map<String, dynamic>? body;
  final UnitType unitType;

  FetchData({
    required this.requestType,
    required this.body,
    required this.unitType,
  });
}

class ConnectToServerEvent extends ApiServiceEvent {
  final ApiEndpoints endpoints;
  ConnectToServerEvent({required this.endpoints});
}
