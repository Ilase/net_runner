part of 'ws_bloc.dart';


abstract class WsEvent {}

class WsConnect extends WsEvent {}
class WsDisconnect extends WsEvent {}