import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

/// Кубит для хранения списка API ответов от серва
class HostListCubit extends Cubit<Map<String, dynamic>> {
  HostListCubit() : super({}); // Переменная для хранения списка API ответа

  void updateState(Map<String, dynamic> json) {
    emit(json);
  }
}
