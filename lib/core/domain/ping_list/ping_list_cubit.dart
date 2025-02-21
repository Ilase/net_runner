import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ping_list_state.dart';

class PingListCubit extends Cubit<PingListState> {
  PingListCubit() : super(PingListInitial());

  void updateState(Map<String, dynamic> json) {
    emit(FilledPingState(list: json));
  }

  void clearState() {
    emit(EmptyState());
  }
}
