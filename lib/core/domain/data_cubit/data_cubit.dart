import 'package:bloc/bloc.dart';
import 'package:net_runner/core/domain/api/api_service_bloc.dart';

abstract class DataState<T> {}

class DataInitialState<T> extends DataState<T> {}

class DataLoadingState<T> extends DataState<T> {}

class DataLoadedState<T> extends DataState<T> {
  final T data;
  DataLoadedState(this.data);
}

class DataErrorState<T> extends DataState<T> {
  final dynamic error;
  DataErrorState(this.error);
}

abstract class BaseCubit<T> extends Cubit<DataState<T>> {
  final ApiServiceBloc apiServiceBloc;
  BaseCubit(this.apiServiceBloc) : super(DataInitialState()) {
    apiServiceBloc.dataStream.listen(
      (data) {
        if (_isDataRelevant(data)) {
          emit(DataLoadedState(data as T));
        }
      },
    ).onError(
      (error) {
        emit(DataErrorState(error));
      },
    );
  }

  bool _isDataRelevant(dynamic data);
}
