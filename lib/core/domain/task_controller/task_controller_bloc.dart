import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/core/data/task_controller.dart';

part 'task_controller_event.dart';
part 'task_controller_state.dart';

class TaskControllerBloc extends Bloc<TaskControllerEvent, TaskControllerState> {
  TaskController? taskVault;
  TaskControllerBloc() : super(TaskControllerInitial()) {
    on<TaskControllerEvent>;
    on<TaskControllerSaveInCache>(_saveVaultInCache);
  }

  Future<void> _saveVaultInCache(TaskControllerSaveInCache event, Emitter emit) async {

  }
  Future<void> _updateTask(TaskControllerUpdateTask event, Emitter emit) async {
    emit(TaskControllerLoaded());
  }
}
