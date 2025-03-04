import 'package:flutter/material.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';

Color getNotificationTypeColor(NotificationType notificationType) {
  switch (notificationType) {
    case NotificationType.success:
      return Colors.lightGreen;
    case NotificationType.warning:
      return Colors.orangeAccent;
    case NotificationType.error:
      return Colors.redAccent;
  }
}
