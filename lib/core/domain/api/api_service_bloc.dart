import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/core/data/api_request_controller/api_request_controller.dart';
import 'package:net_runner/core/data/stream_unit/stream_unit.dart';
import 'package:net_runner/core/data/unit_params/unit_types.dart';
import 'package:net_runner/core/domain/api/api_endpoints.dart';

import '../../data/logger.dart';

part 'api_service_event.dart';
part 'api_service_state.dart';

class ApiServiceBloc extends Bloc<ApiServiceEvent, ApiServiceState> {
  ApiEndpoints? apiEndpoints;
  ApiRequestController? apiRequestController;

  ///Stream
  final StreamController<StreamUnit> _dataController =
      StreamController<StreamUnit>.broadcast();
  Stream<StreamUnit> get dataStream => _dataController.stream;

  ApiServiceBloc({this.apiEndpoints}) : super(ApiServiceInitial()) {}

  Future<void> fetchData(FetchData event, Emitter emit) async {
    if (apiRequestController == null) {
      ntLogger.e("ApiRequestController is not initialized");
      return;
    }

    try {
      dynamic response;

      switch (event.requestType) {
        case ApiRequestType.get:
          response = await apiRequestController!.getRequest(
            endpointKey: event.unitType.toString(),
            queryParams: event.body?.toString(),
          );
          break;
        case ApiRequestType.post:
          response = await apiRequestController!.postRequest(
            endpointKey: event.unitType.toString(),
            body: event.body ?? {},
          );
          break;
        case ApiRequestType.delete:
          response = await apiRequestController!.deleteRequest(
            endpointKey: event.unitType.toString(),
            itemId: event.body?['id']?.toString() ?? '',
          );
          break;
        case ApiRequestType.updateToken:
          response = await apiRequestController!.updateToken(
            event.body ?? {},
          );
          break;
        default:
          throw Exception("Unsupported request type");
      }

      _dataController.add(
        StreamUnit(
          unitType: event.unitType,
          status: StreamUnitStatus.success,
          data: response,
        ),
      );
    } catch (e) {
      ntLogger.e(e);
      _dataController.add(
        StreamUnit(
          unitType: event.unitType,
          status: StreamUnitStatus.error,
          data: {"error": e.toString()},
        ),
      );
    }
  }

  ///Service functions
  void updateEndpoints({
    required ApiEndpoints newEndpoints,
  }) {
    apiEndpoints = newEndpoints;
    apiRequestController = ApiRequestController(apiEndpoints: newEndpoints);
  }

  void addData(dynamic data) {
    _dataController.add(data);
  }

  void dispose() {
    _dataController.close();
  }
}
