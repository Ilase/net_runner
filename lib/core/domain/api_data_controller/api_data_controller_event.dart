
part of 'api_data_controller_bloc.dart';

@immutable
sealed class ApiDataControllerEvent {}
class UpdateDataEvent extends ApiDataControllerEvent {}
class GetRequestEvent extends ApiDataControllerEvent {
  final String endpoint;
  GetRequestEvent({required this.endpoint});
}


class PostRequestEvent extends ApiDataControllerEvent {
  final String endpoint;
  final Map<String, dynamic> body;
  PostRequestEvent({required this.endpoint, required this.body});
}

