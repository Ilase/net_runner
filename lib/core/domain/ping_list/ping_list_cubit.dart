import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ping_list_state.dart';

class PingListCubit extends Cubit<PingListState> {
  PingListCubit() : super(PingListInitial());

  void updateState(List<dynamic> json) {
    emit(PingListFilledState(list: json));
  }

  void setLoadingState() {
    emit(PingListLoadingState());
  }

  void clearState() {
    emit(PingListEmptyState());
  }
}
