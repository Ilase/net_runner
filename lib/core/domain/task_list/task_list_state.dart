part of 'task_list_cubit.dart';

@immutable
sealed class TaskListState {}

final class TaskListInitial extends TaskListState {}

class FilledState extends TaskListState {
  final Map<String, dynamic> list;
  FilledState({required this.list});
}

class LoadingState extends TaskListState {}

class EmptyState extends TaskListState {}
