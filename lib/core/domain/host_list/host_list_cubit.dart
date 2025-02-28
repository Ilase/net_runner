import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

abstract class HostListState {}

final class HostListInitState extends HostListState {}

class FullState extends HostListState {
  final Map<String, dynamic> list;
  FullState({required this.list});
}

class EmptyState extends HostListState {}

/// Кубит для хранения списка API ответов от серва
class HostListCubit extends Cubit<HostListState> {
  HostListCubit()
      : super(HostListInitState()); // Переменная для хранения списка API ответа

  void updateState(Map<String, dynamic> json) {
    emit(FullState(list: json));
  }
}
