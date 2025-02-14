import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'string_list_event.dart';
part 'string_list_state.dart';

class StringListBloc extends Bloc<StringListEvent, StringListState> {
  List<String> stringList = [];
  StringListBloc() : super(StringListInitial()) {
    on<StringListAddElementEvent>(_addElement);
    on<StringListClearEvent>(_clearList);
  }





  Future<void> _addElement(StringListAddElementEvent event, Emitter emit) async{
    try{

    }catch(e){
      emit(StringListErrorState(e.toString()));
    }
  }
  Future<void> _clearList(StringListClearEvent event, Emitter emit) async{

  }
}

