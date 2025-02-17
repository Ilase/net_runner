part of 'graph_request_bloc.dart';

abstract class GraphRequestEvent {}

class GraphRequestGetNetwork extends GraphRequestEvent{
  final String taskName;
  GraphRequestGetNetwork({required this.taskName});
}