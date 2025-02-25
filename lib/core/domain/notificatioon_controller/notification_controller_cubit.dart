import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:net_runner/core/data/notification_model.dart';

part 'notification_controller_state.dart';

class NotificationControllerCubit extends Cubit<NotificationControllerState> {
  NotificationControllerCubit()
      : super(NotificationControllerState(notifications: []));

  void addNotification(String title, String body) {
    final updatedList = List<NotificationModel>.from(state.notifications)
      ..add(NotificationModel(title: title, body: body));
    emit(NotificationControllerState(notifications: updatedList));
  }

  void clearNotifications() {
    emit(const NotificationControllerState(notifications: []));
  }
}
