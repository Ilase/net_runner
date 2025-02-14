import 'package:flutter/material.dart';



class MtGraphPg extends StatefulWidget {
  const MtGraphPg({super.key});

  @override
  _MtGraphPgState createState() => _MtGraphPgState();
}

class _MtGraphPgState extends State<MtGraphPg> with SingleTickerProviderStateMixin {
  late List<Node> nodes;
  late List<Edge> edges;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    nodes = [
      Node(position: const Offset(100, 100), label: 'A'),
      Node(position: const Offset(200, 200), label: 'B'),
      Node(position: const Offset(300, 100), label: 'C'),
    ];
    edges = [
      Edge(from: nodes[0], to: nodes[1]),
      Edge(from: nodes[1], to: nodes[2]),
    ];

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
      setState(() {
        applyForces(nodes, edges);
        updateNodes(nodes);
      });
    });

    controller.repeat();
  }

  void applyForces(List<Node> nodes, List<Edge> edges) {
    const double springLength = 100.0;
    const double springStrength = 0.1;
    const double repulsionStrength = 400.0;
    const double minDistance = 1.0;

    for (var edge in edges) {
      var delta = edge.to.position - edge.from.position;
      var distance = delta.distance;
      if (distance.isNaN || distance < minDistance) continue;
      var force = (springLength - distance) * springStrength;
      var direction = delta / distance;

      edge.from.velocity += direction * force;
      edge.to.velocity -= direction * force;
    }

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        var delta = nodes[j].position - nodes[i].position;
        var distance = delta.distance;
        if (distance.isNaN || distance < minDistance) continue;
        var force = repulsionStrength / (distance * distance);
        var direction = delta / distance;

        nodes[i].velocity -= direction * force;
        nodes[j].velocity += direction * force;
      }
    }
  }


  void updateNodes(List<Node> nodes) {
    const double damping = 0.9;

    for (var node in nodes) {
      node.position += node.velocity;
      node.velocity *= damping;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: GraphPainter(nodes: nodes, edges: edges),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Node {
  Offset position;
  Offset velocity;
  String label;

  Node({required this.position, this.velocity = Offset.zero, required this.label});
}

class Edge {
  Node from;
  Node to;

  Edge({required this.from, required this.to});
}

class GraphPainter extends CustomPainter {
  final List<Node> nodes;
  final List<Edge> edges;

  GraphPainter({required this.nodes, required this.edges});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    for (var edge in edges) {
      canvas.drawLine(edge.from.position, edge.to.position, paint);
    }

    paint.color = Colors.red;
    for (var node in nodes) {
      canvas.drawCircle(node.position, 10, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}