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
  final DataMergeStrategy<T> mergeStrategy;
  BaseCubit({required this.apiServiceBloc, required this.mergeStrategy})
      : super(DataInitialState()) {
    apiServiceBloc.dataStream.listen(
      (data) {
        if (isDataRelevant(data)) {
          emit(DataLoadedState(data as T));
        }
      },
    ).onError(
      (error) {
        emit(DataErrorState(error));
      },
    );
  }

  void _handleNewData(T newData) {
    final currentState = state;
    if (currentState is DataLoadedState<T>) {
      final updatedData = mergeStrategy.merge(currentState.data, newData);
      emit(DataLoadedState(updatedData));
    } else {
      emit(DataLoadedState(newData));
    }
  }

  void addData(T newData) => _handleNewData(newData);

  bool isDataRelevant(dynamic data);
}

abstract class DataMergeStrategy<T> {
  T merge(T currentData, T newData);
}

class AppendToListStrategy<T> implements DataMergeStrategy<List<T>> {
  @override
  List<T> merge(List<T> currentData, List<T> newData) {
    return [...currentData, ...newData];
  }
}

class UpdateOrAddInListStrategy<T extends Identifiable>
    implements DataMergeStrategy<List<T>> {
  @override
  List<T> merge(List<T> currentData, List<T> newData) {
    final newList = [...currentData];
    for (final item in newData) {
      final index = newList.indexWhere((e) => e.ID == item.ID);
      if (index != -1) {
        newList[index] = item;
      } else {
        newList.add(item);
      }
    }
    return newList;
  }
}

class ReplaceStrategy<T> implements DataMergeStrategy<T> {
  @override
  T merge(T currentData, T newData) => newData;
}

abstract class Identifiable {
  dynamic get ID;
}
