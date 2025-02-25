import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_controller_state.dart';

class NotificationControllerCubit extends Cubit<NotificationControllerState> {
  NotificationControllerCubit() : super(NotificationControllerInitial());
}
