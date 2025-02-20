import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  List<dynamic> taskList = [];
  TaskListCubit() : super(TaskListInitial());

  void fillTaskListFromGet(List<dynamic> response) {
    emit(LoadingState());
    taskList = List.from(response);
    emit(FilledState(list: {"taskList": taskList}));
  }

  void updateElementInTaskList(Map<String, dynamic> updatedElement) {
    emit(LoadingState());

    final index =
        taskList.indexWhere((task) => task["ID"] == updatedElement["ID"]);
    final updatedList = List.from(taskList);

    if (index != -1) {
      updatedList[index] = updatedElement;
    } else {
      updatedList.add(updatedElement);
    }

    taskList = updatedList;
    emit(FilledState(list: {"taskList": taskList}));
  }

  void clearList() {
    taskList = [];
    emit(EmptyState());
  }
}
