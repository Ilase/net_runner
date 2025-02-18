part of 'api_bloc.dart';

abstract class ApiEvent {}

class ConnectToServerEvent extends ApiEvent {
  final ApiEndpoints endpoints;
  ConnectToServerEvent({required this.endpoints});
}
