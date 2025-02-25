import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

part 'theme_controller_state.dart';

class ThemeControllerCubit extends Cubit<ThemeData> {
  ThemeControllerCubit() : super(AppTheme.lightTheme);

  void toggleTheme() {
    emit(state.brightness == Brightness.light
        ? AppTheme.darkTheme
        : AppTheme.lightTheme);
  }
}
