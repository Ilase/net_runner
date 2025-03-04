import 'package:flutter/material.dart';
import 'package:net_runner/features/head_page/head_page.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class LoginPage extends StatelessWidget {
  static String route = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Логин',
                    ),
                    readOnly: false,
                  ),
                  const SizedBox(height: 15),
                  const TextField(
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
                      Navigator.of(context).pushNamed(HeadPage.route);
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
    );
  }
}
