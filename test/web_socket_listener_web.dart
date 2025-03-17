import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebSocketExample(),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  WebSocketChannel? channel;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  Future<void> _connectToWebSocket() async {
    final uri = Uri.parse('ws://192.168.20.193:3002/api/v1/ws');
    final headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDIyODM3NDUsInJvbGUiOiJhZG1pbiIsInVzZXJuYW1lIjoiSWxhc2UifQ.zQja-BLuyEU4CaGxsobkZuBdTAwgg8o6nXQauFgqbNU',
    };

    final client = HttpClient();
    final request = await client.getUrl(uri);

    // Add custom headers
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();

    if (response.statusCode == 101) {
      // Upgrade to WebSocket
      final socket = await response.detachSocket();
      final webSocket = await WebSocket.fromUpgradedSocket(
        socket,
        serverSide: false,
      );
      channel = IOWebSocketChannel(webSocket);
      setState(() {});
    } else {
      throw Exception('Failed to connect to WebSocket');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Client with Headers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: channel?.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && channel != null) {
      channel!.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    channel?.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
