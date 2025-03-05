import 'package:bloc/bloc.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataInitial());

  void login() async {
    emit(UserLogInState(login: "login", name: "name"));
  }
}
