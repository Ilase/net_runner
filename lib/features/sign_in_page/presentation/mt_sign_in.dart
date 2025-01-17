import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:net_runner/core/presentation/mt_headpage.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';

class MtSignIn extends StatefulWidget {
  static const String route = '/auth';
  MtSignIn({super.key});

  @override
  State<MtSignIn> createState() => _MtSignInState();
}

class _MtSignInState extends State<MtSignIn> {
  bool _isDirecionalConnect = false;

  TextEditingController _socketController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      builder: (context, state) {
        return BlocListener<WebSocketBloc, WebSocketState>(
          listener: (context, state) {
            if (state is WebSocketConnected) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Connected")));
            }
            if (state is WebSocketErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Error")));
            }
          },
          child: Scaffold(
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
                child: SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Вход*"),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Логин*',
                      ),
                      readOnly: false,
                    ),
                    SizedBox(height: 15),
                    TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Пароль*',
                      ),
                      readOnly: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String socketText = _socketController.text;
                        context.read<WebSocketBloc>().add(WebSocketConnect());
                        if (context.read<WebSocketConnect>().props == 1) {
                          print(123);
                        }
                        Navigator.of(context).pushNamed(MtHeadpage.route);
                      },
                      child: Text('Войти'),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isDirecionalConnect = !_isDirecionalConnect;
                          });
                        },
                        icon: _isDirecionalConnect
                            ? const Icon(Icons.arrow_drop_up_sharp)
                            : const Icon(Icons.arrow_drop_down_sharp)),
                    _isDirecionalConnect
                        ? TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Сокет*',
                            ),
                            controller: _socketController,
                          )
                        : SizedBox(),
                  ],
                  //),
                ),
              ),
            )),
          ),
        );
      },
    );
  }
}
