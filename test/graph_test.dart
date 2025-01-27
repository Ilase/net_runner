import 'package:flutter/material.dart';
import 'package:net_runner/features/graph/graph_pg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Graph Visualization'),
        ),
        body: MtGraphPg(),
      ),
    );
  }
}
