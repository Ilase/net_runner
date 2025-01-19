import 'package:flutter/material.dart';
import 'package:net_runner/features/graph/graph_pg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Graph Visualization'),
        ),
        body: MtGraphPg(),
      ),
    );
  }
}
