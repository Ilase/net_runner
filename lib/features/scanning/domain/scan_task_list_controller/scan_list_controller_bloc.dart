import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/core/domain/web_data_repo/web_data_repo_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'scan_list_controller_event.dart';
part 'scan_list_controller_state.dart';

class ScanListControllerBloc
    extends Bloc<ScanListControllerEvent, ScanListControllerState> {
  late final WebSocketChannel channel;
  StreamSubscription? _subscription;

  ScanListControllerBloc() : super(ScanListControllerInitial()) {
    on<ScanListControllerEvent>;
  }

  Future<void> _disconnectWs() async {}

  Future<void> _connectWs() async {}

  Future<void> _updateList() async {}
  Future<void> _onAddOrUpdateElement() async {}
}
