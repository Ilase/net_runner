import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';

part 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  List<ModelTask> taskList = [];
  TaskListCubit() : super(TaskListInitial());

  void fillTaskListFromGet(List<ModelTask> response) {
    taskList = List.from(response);
    emit(FilledState(list: response));
  }

  void updateElementInTaskList(ModelTask updatedElement) {
    final index = taskList.indexWhere((task) => task.ID == updatedElement.ID);

    final updatedList = [...taskList];

    if (index != -1) {
      updatedList[index] = updatedElement;
    } else {
      updatedList.add(updatedElement);
    }

    /// Используем copyWith, чтобы не терять другие данные
    emit(FilledState(list: updatedList));
  }

  void clearList() {
    taskList = [];
    emit(EmptyState());
  }
}
