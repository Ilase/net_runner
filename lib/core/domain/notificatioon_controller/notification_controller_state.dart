part of 'notification_controller_cubit.dart';

class NotificationControllerState extends Equatable {
  final List<NotificationModel> notifications;
  const NotificationControllerState({required this.notifications});

  @override
  // TODO: implement props
  List<Object?> get props => [notifications];
}
