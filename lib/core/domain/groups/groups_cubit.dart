import 'package:net_runner/core/domain/api/api_service_bloc.dart';
import 'package:net_runner/core/domain/data_cubit/data_cubit.dart';

class GroupsCubit extends BaseCubit<List<GroupsCubit>> {
  GroupsCubit(ApiServiceBloc apiService)
      : super(
          apiServiceBloc: apiService,
          mergeStrategy: ReplaceStrategy(),
        );

  @override
  bool isDataRelevant(dynamic data) {
    return data is List<GroupsCubit>;
  }
}
