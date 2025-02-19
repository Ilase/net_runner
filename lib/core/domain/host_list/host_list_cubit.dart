import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


/// Кубит для хранения списка API ответов от серва
class ApiListCubit extends Cubit<Map<String, dynamic>> {
  String? std;
  ApiListCubit() : super({}); // Переменная для хранения списка API ответа

  void updateState(Map<String, dynamic> json) {
    emit(json);
  }
}
