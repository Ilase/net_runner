part of 'scan_list_controller_bloc.dart';

abstract class ScanListControllerState {}

class ScanListControllerInitial extends ScanListControllerState {}

class ErrorState extends ScanListControllerState {
  final String error;
  ErrorState({required this.error});
}

class ListState extends ScanListControllerState {
  final List<Map<String, dynamic>> list;
  ListState(this.list);

  ListState copyWith({List<Map<String, dynamic>>? elements}) {
    return ListState(elements ?? list);
  }
}
