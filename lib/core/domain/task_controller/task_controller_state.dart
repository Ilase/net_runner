part of 'task_controller_bloc.dart';

@immutable
sealed class TaskControllerState {}

final class TaskControllerInitial extends TaskControllerState {}
class TaskControllerLoaded extends TaskControllerState {
  final tasks;
  TaskControllerLoaded({required this.tasks});
}
class TaskControllerError extends TaskControllerState {}