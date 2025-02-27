import 'package:flutter/material.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/core/presentation/head_page.dart';

class MtSignIn extends StatelessWidget {
  const MtSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AutoSizeText(
          AppLocalizations.of(context)!.appBarAppTitle,
          minFontSize: 36,
          maxFontSize: 48,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Container(),
            // Positioned(
            //   top: 220,
            //   left: 400,
            //   bottom: 220,
            //   right: 400,
              //child:
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
              )
            ),
          ],
        ),
      ),
    );
  }
}
