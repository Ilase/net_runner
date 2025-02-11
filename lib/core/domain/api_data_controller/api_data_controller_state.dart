part of 'api_data_controller_bloc.dart';

@immutable
abstract class ApiDataControllerState extends Equatable {}

final class ApiDataControllerInitial extends ApiDataControllerState {
  @override
  List<Object?> get props => [];
}

class CurrentState extends ApiDataControllerState {

  final List<dynamic> hostList;
  final List<Map<String,dynamic>> taskList;
  final Map<String,dynamic> hostPingList;
  CurrentState({
    required this.hostList,
    required this.taskList,
    required this.hostPingList
  });

  @override
  List<Object?> get props => [];
}

