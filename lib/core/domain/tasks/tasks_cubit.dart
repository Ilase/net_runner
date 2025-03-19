import 'package:net_runner/core/data/stream_unit/stream_unit.dart';
import 'package:net_runner/core/domain/api/api_service_bloc.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';
import 'package:net_runner/core/domain/data_cubit/data_cubit.dart';

class TasksCubit extends BaseCubit<List<ModelTask>> {
  TasksCubit(ApiServiceBloc apiService)
      : super(
          apiServiceBloc: apiService,
          mergeStrategy: UpdateOrAddInListStrategy(),
        );

  @override
  bool isDataRelevant(StreamUnit data) {
    return data is ModelTask;
  }
}
