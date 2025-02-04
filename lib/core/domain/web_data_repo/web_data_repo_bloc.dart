import 'package:bloc/bloc.dart';

part 'web_data_repo_event.dart';
part 'web_data_repo_state.dart';


class ElementBloc extends Bloc<ElementEvent, ElementState> {
  ElementBloc() : super(ElementState([])) {
    on<AddOrUpdateElement>(_onAddOrUpdateElement);
    on<SetElements>(_onSetElements);
  }

  void _onAddOrUpdateElement(AddOrUpdateElement event, Emitter<ElementState> emit) {
    final updatedElements = List<Map<String, dynamic>>.from(state.elements);
    final index = updatedElements.indexWhere((e) => e['ID'] == event.element['ID']);
    print('getted elements ${event.element}');
    if (index != -1) {
      updatedElements[index] = event.element;
      print('Element updated: ${event.element}*');
    } else {
      updatedElements.add(event.element);
      print('Element added: ${event.element}*');
    }

    emit(state.copyWith(elements: updatedElements));
    print('State updated: ${state.elements.length} elements*');
  }

  void _onSetElements(SetElements event, Emitter<ElementState> emit) {
    emit(state.copyWith(elements: event.elements));
  }
}
