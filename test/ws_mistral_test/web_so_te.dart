import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'web_socket_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => WebSocketBloc(
          'ws://192.168.20.140:80/wsscan',
          {
          "uid" : "1378500800859113",
          "token":"3045022100f9e2e5e01ac12458f7c1f7753d1584a3527fc1d17df0466baf61e3de4a61a2c5022009bfe43ac628ac4d0ff55c2098dee5332c64dfbf5b90f500665988f46e87abef"
          }
        ),
        child: WebSocketScreen(),
      ),
    );
  }
}

class WebSocketScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket BLoC Example'),
      ),
      body: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketConnecting) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WebSocketConnected) {
            return Column(
              children: [
                Expanded(
                  child: BlocListener<WebSocketBloc, WebSocketState>(
                    listener: (context, state) {
                      if (state is WebSocketMessage) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Received: ${state.message}')),
                        );
                      } else if (state is WebSocketErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${state.error}')),
                        );
                      }
                    },
                    child: Container(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(labelText: 'Message'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          context
                              .read<WebSocketBloc>()
                              .add(WebSocketSendMessage(_controller.text));
                          _controller.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is WebSocketDisconnected) {
            return Center(child: Text('Disconnected'));
          } else {
            return Center(child: Text('Initial State'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<WebSocketBloc>().add(WebSocketConnect());
        },
        child: Icon(Icons.link),
      ),
    );
  }
}
