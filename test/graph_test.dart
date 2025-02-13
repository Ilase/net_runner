import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final Graph graph = Graph();
  final Map<int, bool> _expandedNodes = {}; // Отслеживание состояния узлов

  @override
  void initState() {
    super.initState();

    // Создаем узлы
    List<Node> nodes = List.generate(10, (index) => Node.Id(index + 1));

    // Соединяем все узлы друг с другом
    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        graph.addEdge(nodes[i], nodes[j]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Obsidian Graph")),
      body: InteractiveViewer(
        constrained: false,
        child: GraphView(
          graph: graph,
          algorithm: FruchtermanReingoldAlgorithm(
            attractionRate: 0.1,
            repulsionPercentage: 1.99,
            iterations: 3000,
          ),
          paint: Paint()
            ..color = Colors.blue
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
          builder: (Node node) {
            return _buildNode(node.key!.value);
          },
        ),
      ),
    );
  }

  Widget _buildNode(int id) {
    bool isExpanded = _expandedNodes[id] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedNodes[id] = !(isExpanded);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.only(bottom: isExpanded ? 60 : 16), // Изменяем размер при нажатии
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          '192.168.20.$id',
          style: TextStyle(color: Colors.white,),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: GraphPage()));
}
