import 'package:flutter/material.dart';
import 'package:net_runner/features/head_page/head_page.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class MtSignIn extends StatelessWidget {
  const MtSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(),
            Center(
                child: Container(
              width: 300, // Фиксированная ширина
              height: 400, // Фиксированная высота
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
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Войти"),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Электронная почта',
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Забыли пароль? Восстановить',
                        style: AppTheme.lightTheme.textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeadPage(),
                          ),
                        );
                      },
                      child: const Text('Войти'),
                    ),
                  ],
                  //),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
