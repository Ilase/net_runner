
part of 'api_data_controller_bloc.dart';

@immutable
sealed class ApiDataControllerEvent {}
class UpdateDataEvent extends ApiDataControllerEvent {}
class GetRequestEvent extends ApiDataControllerEvent {
  final String endpoint;
  GetRequestEvent({required this.endpoint});
}
