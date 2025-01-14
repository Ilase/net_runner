import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:net_runner/core/data/user_repository.dart';

part 'user_repository_event.dart';
part 'user_repository_state.dart';




class UserRepositoryBloc extends Bloc<UserRepositoryEvent, UserRepositoryState> {
  final cache = DefaultCacheManager();
  List<UserRepository> users = [
    UserRepository({
      "login" : "login",
      "passkey" : "pass"
    }, {})
  ];

  UserRepositoryBloc() : super(UserRepositoryInitial()) {
    // implement 'on'
    on<URSaveUserDataEvent>(_saveUserRepositoryToCache);
    on<URLoginUserEvent>(_login);

  }

  Future<void> _login(URLoginUserEvent event, Emitter emit) async {
    for(var i in users){
      if(i.userData["login"].hashCode == event.jsonUserData["login"].hashCode){
        emit(UserRepositoryLoginSuccessState());
      } else {
        emit(UserRepositoryLoginFailedState());
      }
    }
  }
  Future<void> _loadUserRepositoryFromCache(URLoadUserDataEvent event, Emitter emit) async {
    final cachedUserData = await cache.getFileFromMemory('list_of_users');
    emit(UserLoadedState());
  }

  Future<void> _saveUserRepositoryToCache(URSaveUserDataEvent event, Emitter emit) async {
    cache.putFile('json_user_data', event.jsonUserData);
  }
  // Future<void> _logout(UR){
  //   emit(UserNotLoggedInState());
  // }
}

