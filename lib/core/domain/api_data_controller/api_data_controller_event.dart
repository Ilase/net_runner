part of 'api_data_controller_bloc.dart';

@immutable
sealed class ApiDataControllerEvent {}
class UpdateDataEvent extends ApiDataControllerEvent {}
