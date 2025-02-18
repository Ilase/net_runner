import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/core/data/logger.dart';

part 'scan_task_list_event.dart';
part 'scan_task_list_state.dart';

class ScanTaskListBloc extends Bloc<ScanTaskListEvent, ScanTaskListState> {
  ScanTaskListBloc() : super(ScanTaskListState([])) {
    on<AddOrUpdateElement>(_onAddOrUpdateElement);
    on<SetElements>(_onSetElements);
  }
  void _onAddOrUpdateElement(
    AddOrUpdateElement event,
    Emitter<ScanTaskListState> emit,
  ) {
    final updatedElements = List<Map<String, dynamic>>.from(state.tasks);
    final index =
        updatedElements.indexWhere((e) => e['ID'] == event.element['ID']);
    ntLogger.w('got elements ${event.element}');
    if (index != -1) {
      updatedElements[index] = event.element;
      ntLogger.w('Element updated: ${event.element}*');
    } else {
      updatedElements.add(event.element);
      ntLogger.w('Element added: ${event.element}*');
    }

    emit(state.copyWith(tasks: updatedElements));
    ntLogger.w('State updated: ${state.tasks.length} elements*');
  }

  void _onSetElements(SetElements event, Emitter<ScanTaskListState> emit) {
    emit(state.copyWith(tasks: event.elements));
  }
}
