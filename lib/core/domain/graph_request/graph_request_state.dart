part of 'graph_request_bloc.dart';

@immutable
sealed class GraphRequestState {}

final class GraphRequestInitial extends GraphRequestState {}

class GraphRequestSuccess extends GraphRequestState{
  final Map<String,dynamic> graphJson;
  GraphRequestSuccess({required this.graphJson});
}

class GraphRequestFailure extends GraphRequestState {
  final String error;
  GraphRequestFailure({required this.error});
}

class GraphRequestInProgress extends GraphRequestState {}