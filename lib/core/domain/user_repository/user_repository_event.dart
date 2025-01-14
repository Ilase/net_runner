part of 'user_repository_bloc.dart';

abstract class UserRepositoryEvent {}

class URReloadDataEvent extends UserRepositoryEvent{}

class URLoadUserDataEvent extends UserRepositoryEvent{
  var jsonUserData;
  URLoadUserDataEvent(this.jsonUserData);

}
class URSaveUserDataEvent extends UserRepositoryEvent{
  var jsonUserData;
  URSaveUserDataEvent(this.jsonUserData);
}

class URLogoutUserEvent extends UserRepositoryEvent {
  var jsonUserData;
  URLogoutUserEvent(this.jsonUserData);
}
class URLoginUserEvent extends UserRepositoryEvent {
  var jsonUserData;
  URLoginUserEvent(this.jsonUserData);
}