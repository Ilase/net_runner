part of 'notification_controller_cubit.dart';

sealed class NotificationControllerState extends Equatable {
  const NotificationControllerState();
}

final class NotificationControllerInitial extends NotificationControllerState {
  @override
  List<Object> get props => [];
}

class NotificationReceived extends NotificationControllerState {
  final String messageTitle;
  final String messageBody;

  const NotificationReceived(
      {required this.messageBody, required this.messageTitle});

  @override
  List<Object?> get props => [messageBody, messageTitle];
}
