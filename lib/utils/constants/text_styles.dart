import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AppTextStyle {
  static const titleText = AutoSizeText(
    'NetRunner',
    minFontSize: 36,
    maxFontSize: 48,
    overflow: TextOverflow.ellipsis,
  );

}