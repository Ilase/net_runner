import 'package:flutter/material.dart';

Color getTaskStatusColor(String status) {
  if (status == "error") {
    return Colors.redAccent;
  } else if (status == "completed") {
    return Colors.lightGreen;
  } else {
    return Colors.orangeAccent;
  }
}
