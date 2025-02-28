part of 'api_bloc.dart';

abstract class ApiState {}

final class ApiInitial extends ApiState {}

class ConnectedState extends ApiState {}

class ErrorState extends ApiState {
  final String messageTitle;
  final String messageBody;
  ErrorState({required this.messageTitle, required this.messageBody});
}

class ConnectLoadState extends ApiState {}
