import 'dart:io';

import 'package:flutter/foundation.dart';

Future<String> detectOpSys() async {
  String platform = Platform.operatingSystem;
  if (kIsWeb) {
    platform = "web";
  }
  return platform;
}
