import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/data_loader.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/core/presentation/head_page.dart';
import 'package:net_runner/core/presentation/widgets/router.dart';
import 'package:net_runner/features/splash_screen/splash_screen.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class InitWsConnectionPage extends StatefulWidget {
  static const String route = '/init';
  const InitWsConnectionPage({super.key});

  @override
  State<InitWsConnectionPage> createState() => _InitWsConnectionPageState();
}

class _InitWsConnectionPageState extends State<InitWsConnectionPage> {
  final TextEditingController _uriAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;
    return Scaffold(
      body: Center(
        child: BlocListener<WebSocketBloc, WebSocketState>(
          listener: (context, state) {
            if(state is WebSocketError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.toString())));
            }
            if(state is WebSocketConnected){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connected*')));
              Navigator.of(context).pushNamed('/head');
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Server address*'),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Enter address with port*',
                    style: AppTextStyle.lightTextTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[\d\.\:]+$')),
                    ],
                    controller: _uriAddress,
                    decoration: InputDecoration(labelText: 'Address*'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if(!_uriAddress.text.isEmpty){
                          context.read<WebSocketBloc>().add(
                              WebSocketConnect(
                                  'ws://${_uriAddress.text}/api/v1/ws'));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields*')));
                        }
                      },
                      child: Text('Connect'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
