part of 'user_data_cubit.dart';

abstract class UserDataState {}

final class UserDataInitial extends UserDataState {}

class UserLogInState extends UserDataState {
  final String login;
  final String name;
  UserLogInState({required this.login, required this.name});
}

class UserLogOutState extends UserDataState {}
