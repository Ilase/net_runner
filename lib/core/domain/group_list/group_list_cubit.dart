import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

abstract class GroupListState {}

class FilledState extends GroupListState {
  final Map<String, dynamic> list;
  FilledState({required this.list});
}

class EmptyState extends GroupListState {}

/// Кубит для хранения списка API ответов от серва
class GroupListCubit extends Cubit<GroupListState> {
  GroupListCubit()
      : super(EmptyState()); // Переменная для хранения списка API ответа

  void updateState(Map<String, dynamic> json) {
    emit(FilledState(list: json));
  }
}
