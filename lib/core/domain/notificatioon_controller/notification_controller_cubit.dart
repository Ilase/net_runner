import 'package:bloc/bloc.dart';
import 'package:net_runner/core/data/notification/notification_model.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';

part 'notification_controller_state.dart';

class NotificationControllerCubit extends Cubit<NotificationControllerState> {
  NotificationControllerCubit()
      : super(NotificationControllerState(notifications: []));

  void addNotification(
      String title, String body, NotificationType notificationType) {
    final updatedList = List<NotificationModel>.from(state.notifications)
      ..add(NotificationModel(
          title: title, body: body, notificationType: notificationType));

    emit(NotificationControllerState(notifications: updatedList));
  }

  void clearNotifications() {
    emit(const NotificationControllerState(notifications: []));
  }
}
