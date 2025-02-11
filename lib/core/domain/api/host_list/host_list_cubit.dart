import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'host_list_state.dart';

  class HostListCubit extends Cubit<HostListState> {

  HostListCubit() : super(HostListInitialState()){
    emit(FullState(hostList: []));
  }

  void updateState(List<dynamic> hostList){

    emit(FullState(hostList: hostList));
  }
}
