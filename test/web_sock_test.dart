import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:convert';

import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => WebSocketBloc(),
        child: WebSocketExample(),
      ),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  bool _isFormVisible = false;

  @override
  void initState() {
    super.initState();
    context
        .read<WebSocketBloc>()
        .add(WebSocketConnect('ws://192.168.20.140:8080/wsscan'));
  }

  @override
  void dispose() {
    context.read<WebSocketBloc>().add(WebSocketDisconnect());
    super.dispose();
  }

  void _sendJsonMessage() {
    Map<String, dynamic> jsonMessage = {
      "uid": 10101,
      "request_time": "2024-12-11 14:09",
      "hosts": [_controller.text],
      "ports": "80",
      "speed": "4"
    };
    String jsonString = jsonEncode(jsonMessage);
    context.read<WebSocketBloc>().add(WebSocketSendMessage(jsonString));
    _controller.clear();
    setState(() {
      _isFormVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Example'),
      ),
      body: BlocListener<WebSocketBloc, WebSocketState>(
        listener: (context, state) {
          if (state is WebSocketMessageState) {
            setState(() {
              messages.add(state.message);
            });
          }
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isFormVisible = !_isFormVisible;
                      });
                    },
                    child: Text(_isFormVisible ? 'Close Form' : 'Open Form'),
                  ),
                ],
              ),
            ),
            if (_isFormVisible)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter JSON content',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _sendJsonMessage,
                      child: Text('Send JSON'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(messages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
