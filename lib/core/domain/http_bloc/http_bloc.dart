import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';

abstract class HttpEvent {}

class FetchElements extends HttpEvent {}

class HttpBloc extends Bloc<HttpEvent, void> {
  final ElementBloc elementBloc;
  //final String uri;

  HttpBloc(this.elementBloc) : super(HttpBlocInitialState()) {
    on<FetchElements>(_onFetchElements);
  }

  Future<void> _onFetchElements(FetchElements event, Emitter<void> emit) async {
    // Пример GET-запроса
    final List<Map<String, dynamic>> fetchedElements = await fetchAllElements();

    // Обновляем состояние в ElementBloc
    elementBloc.add(SetElements(fetchedElements));
  }

  Future<List<Map<String, dynamic>>> fetchAllElements() async {
    // Имитируем запрос
    await Future.delayed(Duration(seconds: 2));
    return [
      {'id': 1, 'name': 'Item 1'},
      {'id': 2, 'name': 'Item 2'},
    ];
  }
}

class HttpBlocState {}
class HttpBlocInitialState extends HttpBlocState{
}
