import 'package:bloc/bloc.dart';
import 'package:net_runner/core/domain/api/models/group/group_serial.dart';

abstract class GroupListState {}

class GroupListFullState extends GroupListState {
  final List<ModelGroup> list;
  GroupListFullState({required this.list});
}

class EmptyState extends GroupListState {}

/// Кубит для хранения списка API ответов от серва
class GroupListCubit extends Cubit<GroupListState> {
  GroupListCubit()
      : super(EmptyState()); // Переменная для хранения списка API ответа

  void updateState(List<Map<String, dynamic>> json) {
    //List<ModelGroup> groups = json.map((e) => ModelGroup.fromJson(e)).toList();
    List<ModelGroup> groups = json.map((e) => ModelGroup.fromJson(e)).toList();
    emit(GroupListFullState(list: groups));
  }
}
