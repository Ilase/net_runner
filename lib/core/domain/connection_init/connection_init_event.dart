part of 'connection_init_bloc.dart';

abstract class ConnectionInitEvent {}

class ConnectionInitCheckEvent extends ConnectionInitEvent {
  final String uri;
  ConnectionInitCheckEvent({required this.uri});
}