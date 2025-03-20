import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

IconData getIconForCPE(String cpe) {
  if (cpe.contains("windows")) {
    return MaterialCommunityIcons.windows;
  }
  if (cpe.contains("linux")) {
    return MaterialCommunityIcons.linux;
  }
  if (cpe.contains("apple")) {
    return MaterialCommunityIcons.apple;
  }
  if (cpe.contains("dlink")) {
    return MaterialCommunityIcons.router_wireless;
  }
  if (cpe.contains("vmware")) {
    return FontAwesome5Icon.window_maximize;
  }
  if (cpe.contains("axis")) {
    return MaterialCommunityIcons.camera_gopro;
  }

  return Icons.device_unknown;
}
