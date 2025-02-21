part of 'task_list_cubit.dart';

@immutable
sealed class TaskListState extends Equatable {}

final class TaskListInitial extends TaskListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FilledState extends TaskListState {
  final Map<String, dynamic> list;
  FilledState({required this.list});
  @override
  // TODO: implement props
  List<Object?> get props => [list];
}

class LoadingState extends TaskListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmptyState extends TaskListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
