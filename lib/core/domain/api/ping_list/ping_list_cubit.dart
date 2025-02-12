import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ping_list_state.dart';

class PingListCubit extends Cubit<PingListState> {
  PingListCubit() : super(PingListInitial()){
    emit(EmptyState());
  }
  void updateState(Map<String,dynamic> pingMap){
    emit(FullState(pingMap: pingMap));
  }
}
