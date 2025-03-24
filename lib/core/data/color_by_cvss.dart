import 'dart:ui';

import 'package:flutter/material.dart';

Color getColorByCveCvss(String cvss) {
  double? dCvss = double.tryParse(cvss);

  if (dCvss != null) {
    if (dCvss <= 0.1) {
      return Colors.grey;
    }
    if (dCvss >= 0.1 && dCvss <= 3.9) {
      return Colors.lightGreen;
    }
    if (dCvss >= 4.0 && dCvss <= 6.9) {
      return Colors.orangeAccent;
    }
    if (dCvss >= 7.0 && dCvss <= 8.9) {
      return Colors.redAccent;
    }
    if (dCvss >= 9.0 && dCvss <= 10.0) {
      return Colors.redAccent.shade700;
    }
  }
  return Colors.grey;
}
