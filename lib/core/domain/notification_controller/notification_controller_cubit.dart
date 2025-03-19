import 'package:net_runner/core/data/notification/notification_model.dart';
import 'package:net_runner/core/domain/api/api_service_bloc.dart';
import 'package:net_runner/core/domain/data_cubit/data_cubit.dart';

class NotificationControllerCubit extends BaseCubit<List<NotificationModel>> {
  NotificationControllerCubit(ApiServiceBloc apiService)
      : super(
          apiServiceBloc: apiService,
          mergeStrategy: AppendToListStrategy(),
        );

  @override
  bool isDataRelevant(dynamic data) {
    return data is NotificationModel;
  }
}
