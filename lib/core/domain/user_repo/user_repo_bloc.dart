import 'package:bloc/bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/core/data/task_controller.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';

part 'user_repo_event.dart';
part 'user_repo_state.dart';

class UserRepoBloc extends Bloc<UserRepoEvent, UserRepoState> {

  final cacheManager = DefaultCacheManager();
  WebSocketBloc? webSocketBloc;
  UserRepoBloc() : super(UserRepoInitial()) {

  }


}
