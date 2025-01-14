part of 'ws_bloc.dart';


abstract class WsState extends Equatable{
  const WsState();

  @override
  List<Object?> get props => [];
}

class WsInitial extends WsState {}
class WsConnect extends WsState {}
class WsDisconnect extends WsState {}
class WsMessage extends WsState {}