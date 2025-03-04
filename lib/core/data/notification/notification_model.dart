import 'package:net_runner/core/presentation/widgets/notification_manager.dart';

class NotificationModel {
  final String title;
  final String body;
  final NotificationType notificationType;
  NotificationModel({
    required this.title,
    required this.body,
    required this.notificationType,
  });
}
