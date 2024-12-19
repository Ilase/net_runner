import 'dart:io';
import 'package:flutter/foundation.dart';

Future<String> detectOpSys() async {
  String platform = Platform.operatingSystem;
  return platform;
}
