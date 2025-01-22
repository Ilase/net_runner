part of 'task_controller_bloc.dart';

@immutable
sealed class TaskControllerState {}

final class TaskControllerInitial extends TaskControllerState {}
class TaskControllerLoaded extends TaskControllerState {}
class TaskControllerError extends TaskControllerState {}