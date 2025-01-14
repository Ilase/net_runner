part of 'ws_bloc.dart';


abstract class WsState extends Equatable{
  const WsState();

  @override
  List<Object?> get props => [];
}

class WsInitial extends WsState {}
class WsConnected extends WsState {}
class WsDisconnected extends WsState {}
class WsMessage extends WsState {}