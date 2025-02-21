import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/core/data/logger.dart';

part 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  List<dynamic> taskList = [];
  TaskListCubit() : super(TaskListInitial());

  void fillTaskListFromGet(List<dynamic> response) {
    taskList = List.from(response);
    emit(FilledState(list: {"taskList": taskList}));
  }

  void updateElementInTaskList(Map<String, dynamic> updatedElement) {
    ntLogger.i('TASKS UPDATE: \n\n${updatedElement}');

    final index =
        taskList.indexWhere((task) => task["ID"] == updatedElement["ID"]);

    /// Создаём новый список, чтобы Flutter точно увидел изменения
    final updatedList = [...taskList];

    if (index != -1) {
      updatedList[index] = updatedElement; // Обновляем элемент
    } else {
      updatedList.add(updatedElement); // Добавляем новый
    }

    /// Используем copyWith, чтобы не терять другие данные
    emit(FilledState(list: {"taskList": updatedList}));
  }

  void clearList() {
    taskList = [];
    emit(EmptyState());
  }
}
