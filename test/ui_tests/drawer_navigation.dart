import 'package:flutter/material.dart';

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
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  static const List<Widget> _pages = <Widget>[
    Icon(Icons.home, size: 150),
    Icon(Icons.business, size: 150),
    Icon(Icons.school, size: 150),
  ];

  static const List<NavigationRailDestination> _navRailDestinations =
      <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.home),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.business),
      label: Text('Business'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.school),
      label: Text('School'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isDrawerOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NavigationRail and Drawer Example'),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            destinations: _navRailDestinations,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: _pages[_selectedIndex],
            ),
          ),
          if (_isDrawerOpen)
            Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Drawer Header',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      setState(() {
                        _isDrawerOpen = false;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.business),
                    title: Text('Business'),
                    onTap: () {
                      setState(() {
                        _isDrawerOpen = false;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('School'),
                    onTap: () {
                      setState(() {
                        _isDrawerOpen = false;
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
