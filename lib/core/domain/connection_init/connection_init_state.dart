part of 'connection_init_bloc.dart';

@immutable
sealed class ConnectionInitState {}

final class ConnectionInitInitial extends ConnectionInitState {}
class ConnectionInitOk extends ConnectionInitState {}
class ConnectionInitError extends ConnectionInitState {
  final String error;
  ConnectionInitError({required this.error});
}