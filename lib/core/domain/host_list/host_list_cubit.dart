import 'package:bloc/bloc.dart';
import 'package:net_runner/core/domain/api/models/host/host_serial.dart';

abstract class HostListState {}

final class HostListInitState extends HostListState {}

class HostListFullState extends HostListState {
  final List<ModelHost> list;
  HostListFullState({required this.list});
}

class HostListLoadingState extends HostListState {}

class HostListEmptyState extends HostListState {}

/// Кубит для хранения списка API ответов от серва
class HostListCubit extends Cubit<HostListState> {
  HostListCubit()
      : super(HostListInitState()); // Переменная для хранения списка API ответа

  void updateState(List<Map<String, dynamic>> json) {
    List<ModelHost> hosts = json.map((e) => ModelHost.fromJson(e)).toList();
    emit(HostListFullState(list: hosts));
  }

  void setLoadingState() {
    emit(HostListLoadingState());
  }
}
