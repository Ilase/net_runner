import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:net_runner/core/data/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset? _tapPosition;
  bool _isMenuVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Context Menu Example'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onLongPress: () {
              // Обработка долгого нажатия для мобильных устройств
              _showContextMenu(context);
            },
            onSecondaryTapDown: (details) {
              // Обработка нажатия правой кнопкой мыши для веб
              _tapPosition = details.globalPosition;
              _showContextMenu(context);
            },
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    // Обработка обычного нажатия
                    ntLogger.i('Item 1 tapped');
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {
                    // Обработка обычного нажатия
                    ntLogger.i('Item 2 tapped');
                  },
                ),
              ],
            ),
          ),
          if (_isMenuVisible && _tapPosition != null)
            Positioned(
              left: _tapPosition!.dx,
              top: _tapPosition!.dy,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: const Icon(Icons.more_vert),
                  items: const [
                    DropdownMenuItem(
                      value: 'Option 1',
                      child: Text('Option 1'),
                    ),
                    DropdownMenuItem(
                      value: 'Option 2',
                      child: Text('Option 2'),
                    ),
                  ],
                  onChanged: (value) {

                    setState(() {
                      _isMenuVisible = false;
                    });
                    ntLogger.i('Selected: $value');
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    setState(() {
      _isMenuVisible = true;
    });
  }

  void _hideContextMenu() {
    setState(() {
      _isMenuVisible = false;
    });
  }
}
