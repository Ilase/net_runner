import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'checkbox_controller_event.dart';
part 'checkbox_controller_state.dart';

class CheckboxControllerBloc extends Bloc<CheckboxControllerEvent, List<String>> {
  List<String> itemList = [];

  CheckboxControllerBloc() : super([]) {
    on<DelItemEvent>(_delItem);
    on<AddItemEvent>(_addItem);
    on<ClearItemsEvent>(_clearItems);
  }


  Future<void> _addItem(AddItemEvent event , Emitter emit) async {
    state.add(event.item);

  }
  Future<void> _delItem(DelItemEvent event , Emitter emit) async {
    state.remove(event.item);
  }
  Future<void> _clearItems(ClearItemsEvent event , Emitter emit) async {
    state.clear();
  }
}
