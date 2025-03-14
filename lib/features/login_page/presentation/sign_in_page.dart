import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/user_repository/user_data_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';
import 'package:net_runner/features/head_page/head_page.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class LoginPage extends StatelessWidget {
  static String route = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _loginController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return BlocListener<UserDataCubit, UserDataState>(
      listener: (context, state) {
        if (state is UserLogInState) {
          Future.microtask(() {
            //microfuture
            Navigator.of(context).pushNamed(HeadPage.route);
          });

          ///Get info from api
          context.read<ApiBloc>().add(GetHostListEvent());
          context.read<ApiBloc>().add(GetGroupListEvent());
          context.read<ApiBloc>().add(FetchTaskListEvent());
        } else {
          context.read<ApiBloc>().notificationControllerCubit.addNotification(
              "Упс...", "Ошибка авторизации", NotificationType.error);
        }
      },
      child: Scaffold(
        body: Center(
          child: Center(
            child: Container(
              width: 300, // Фиксированная ширина
              height: 300, // Фиксированная высота
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Войти"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _loginController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Логин',
                      ),
                      readOnly: false,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Пароль',
                      ),
                      readOnly: false,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ApiBloc>().add(
                              LoginToServer(
                                login: _loginController.text,
                                password: _passwordController.text,
                              ),
                            );
                      },
                      child: const Text('Войти'),
                    ),
                  ],
                  //),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
