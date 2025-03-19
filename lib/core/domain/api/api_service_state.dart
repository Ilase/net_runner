part of 'api_service_bloc.dart';

@immutable
sealed class ApiServiceState {}

final class ApiServiceInitial extends ApiServiceState {}

class ConnectedToServerState extends ApiServiceState {}
