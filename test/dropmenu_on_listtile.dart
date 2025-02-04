import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
        title: Text('Context Menu Example'),
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
                  title: Text('Item 1'),
                  onTap: () {
                    // Обработка обычного нажатия
                    print('Item 1 tapped');
                  },
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    // Обработка обычного нажатия
                    print('Item 2 tapped');
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
                  customButton: Icon(Icons.more_vert),
                  items: [
                    DropdownMenuItem(
                      child: Text('Option 1'),
                      value: 'Option 1',
                    ),
                    DropdownMenuItem(
                      child: Text('Option 2'),
                      value: 'Option 2',
                    ),
                  ],
                  onChanged: (value) {
                    // Обработка выбора опции
                    setState(() {
                      _isMenuVisible = false;
                    });
                    print('Selected: $value');
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
