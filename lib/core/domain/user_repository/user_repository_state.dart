part of 'user_repository_bloc.dart';


abstract class UserRepositoryState {}

class UserRepositoryInitial extends UserRepositoryState {}
class UserLoadedState extends UserRepositoryState{}
class UserLoggedInState extends UserRepositoryState{}
class UserNotLoggedInState extends UserRepositoryState {}
class UserRepositoryEmptyState extends UserRepositoryState {}
class UserRepositoryLoginSuccessState extends UserRepositoryState {}
class UserRepositoryLoginFailedState extends UserRepositoryState {}
