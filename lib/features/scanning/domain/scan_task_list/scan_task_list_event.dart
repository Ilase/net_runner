part of 'scan_task_list_bloc.dart';

abstract class ScanTaskListEvent {}

class AddOrUpdateElement extends ScanTaskListEvent {
  final Map<String, dynamic> element;

  AddOrUpdateElement(this.element);
}

class SetElements extends ScanTaskListEvent {
  final List<Map<String, dynamic>> elements;

  SetElements(this.elements);
}
