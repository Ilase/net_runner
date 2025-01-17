import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/features/scanning/presentation/widgets/mt_gesture_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:web_socket_channel/io.dart';

import 'ws_bloc_test/ws_bloc.dart';

import 'ws_bloc_test/ws_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String title = 'WebSocket Example';
  TextEditingController _messageFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: BlocProvider<WsBloc>(
        create: (context) =>
          WsBloc( socket: null,
            headers: {
            "uid" : "1378500800859113",
            "token":"3045022100f9e2e5e01ac12458f7c1f7753d1584a3527fc1d17df0466baf61e3de4a61a2c5022009bfe43ac628ac4d0ff55c2098dee5332c64dfbf5b90f500665988f46e87abef"
           }),
        child: Scaffold(
          body: Column(
            children: [
              BlocBuilder(
                  builder: (context, state){
                    if(state is WsJSMessage){
                      return ListView.builder(
                        itemCount: state.message.length,
                        itemBuilder: (context, index){
                          final item = state.message.keys.elementAt(index);
                          final status = state.message;
                          return MtGestureCard(title: item.toString(), status: status["taskStatus"]);
                        }
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }
              ),



              TextField(
                controller: _messageFieldController,
              ),
              IconButton(
                onPressed: (){

                },
                icon: Icon(Icons.send))
            ],
          ),
        )
      ),
    );
  }


}