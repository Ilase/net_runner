part of 'task_controller_bloc.dart';

@immutable
sealed class TaskControllerEvent {}
class TaskControllerLoadTasksInVault extends TaskControllerEvent {}
class TaskControllerUpdateTask extends TaskControllerEvent {}
class TaskControllerSaveInCache extends TaskControllerEvent {}
