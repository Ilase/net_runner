part of 'task_controller_bloc.dart';

@immutable
sealed class TaskControllerEvent {}
class TaskControllerLoadTasksInVault extends TaskControllerEvent {
  final List<Map<String,dynamic>> data;
  TaskControllerLoadTasksInVault({required this.data});
}
class TaskControllerUpdateTask extends TaskControllerEvent {}
class TaskControllerSaveInCache extends TaskControllerEvent {}
