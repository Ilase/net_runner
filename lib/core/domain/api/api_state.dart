part of 'api_bloc.dart';

abstract class ApiState {}

final class ApiInitial extends ApiState {}

class ConnectedState extends ApiState {}

class ConnectErrorState extends ApiState {}

class ConnectLoadState extends ApiState {}
