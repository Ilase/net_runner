part of 'scan_task_list_bloc.dart';

class ScanTaskListState {
  final List<Map<String, dynamic>> tasks;
  ScanTaskListState(this.tasks);

  ScanTaskListState copyWith({List<Map<String, dynamic>>? tasks}) {
    return ScanTaskListState(tasks ?? this.tasks);
  }
}
