import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scan_controller_event.dart';
part 'scan_controller_state.dart';

class ScanControllerBloc extends Bloc<ScanControllerEvent, ScanControllerState> {
  ScanControllerBloc() : super(ScanControllerInitial()) {
    on<ScanControllerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
