import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Node {
  Offset position;
  Offset velocity;
  final Widget child;
  bool isDragging;

  Node({
    required this.position,
    required this.child,
    Offset? velocity,
    this.isDragging = false,
  }) : velocity = velocity ?? Offset.zero;
}

class Edge {
  final int from;
  final int to;
  Edge({required this.from, required this.to});
}

class ForceGraph extends StatefulWidget {
  final List<Node> nodes;
  final List<Edge> edges;
  final double nodeRadius;

  /// Здесь width и height можно не указывать, так как мы будем брать их из LayoutBuilder.
  const ForceGraph({
    Key? key,
    required this.nodes,
    required this.edges,
    this.nodeRadius = 20,
  }) : super(key: key);

  @override
  _ForceGraphState createState() => _ForceGraphState();
}

class _ForceGraphState extends State<ForceGraph>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Size areaSize = Size.zero; // Фактический размер области графа

  // Параметры физики
  final double repulsion = 5000;
  final double springLength = 100;
  final double springStiffness = 0.1;
  final double damping = 0.9;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    _updatePhysics();
    setState(() {});
  }

  void _updatePhysics() {
    // Если реальный размер еще не определён, пропускаем обновление
    if (areaSize == Size.zero) return;

    List<Offset> forces = List.generate(
      widget.nodes.length,
      (_) => Offset.zero,
    );

    // Расчет сил отталкивания между всеми парами узлов
    for (int i = 0; i < widget.nodes.length; i++) {
      for (int j = i + 1; j < widget.nodes.length; j++) {
        Offset delta = widget.nodes[j].position - widget.nodes[i].position;
        double distance = delta.distance + 0.1; // избегаем деления на 0
        Offset direction = delta / distance;
        double force = repulsion / (distance * distance);
        forces[i] -= direction * force;
        forces[j] += direction * force;
      }
    }

    // Расчет силы "пружины" для каждого ребра
    for (Edge edge in widget.edges) {
      Node n1 = widget.nodes[edge.from];
      Node n2 = widget.nodes[edge.to];
      Offset delta = n2.position - n1.position;
      double distance = delta.distance + 0.1;
      Offset direction = delta / distance;
      double displacement = distance - springLength;
      Offset springForce = direction * (springStiffness * displacement);
      forces[edge.from] += springForce;
      forces[edge.to] -= springForce;
    }

    // Обновление скоростей и позиций узлов с ограничением в пределах области
    for (int i = 0; i < widget.nodes.length; i++) {
      Node node = widget.nodes[i];
      if (node.isDragging) continue;
      Offset acceleration = forces[i];
      node.velocity = (node.velocity + acceleration) * damping;
      node.position = node.position + node.velocity * 0.1;

      // Ограничиваем позицию узла, чтобы он не выходил за пределы области
      node.position = Offset(
        node.position.dx.clamp(
          widget.nodeRadius,
          areaSize.width - widget.nodeRadius,
        ),
        node.position.dy.clamp(
          widget.nodeRadius,
          areaSize.height - widget.nodeRadius,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Используем LayoutBuilder, чтобы получить реальные размеры области
    return LayoutBuilder(
      builder: (context, constraints) {
        // Обновляем размер области графа
        areaSize = Size(constraints.maxWidth, constraints.maxHeight);

        return SizedBox(
          width: areaSize.width,
          height: areaSize.height,
          child: CustomPaint(
            painter: _GraphPainter(widget.nodes, widget.edges),
            child: Stack(
              children: widget.nodes.asMap().entries.map((entry) {
                int index = entry.key;
                Node node = entry.value;
                return Positioned(
                  left: node.position.dx - widget.nodeRadius,
                  top: node.position.dy - widget.nodeRadius,
                  width: widget.nodeRadius * 2,
                  height: widget.nodeRadius * 2,
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        node.isDragging = true;
                        node.velocity = Offset.zero;
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        node.position += details.delta;
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        node.isDragging = false;
                      });
                    },
                    child: node.child,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _GraphPainter extends CustomPainter {
  final List<Node> nodes;
  final List<Edge> edges;

  _GraphPainter(this.nodes, this.edges);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    for (Edge edge in edges) {
      Offset p1 = nodes[edge.from].position;
      Offset p2 = nodes[edge.to].position;
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HomeGraphPage extends StatefulWidget {
  const HomeGraphPage({super.key});

  @override
  State<HomeGraphPage> createState() => _HomeGraphPageState();
}

List<Node> nodes = List.generate(100, (index) {
  final random = Random();
  return Node(
    position: Offset(
      random.nextDouble() * 300 + 20,
      random.nextDouble() * 500 + 20,
    ),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.primaries[index % Colors.primaries.length],
      ),
      child: Center(child: Text(index.toString())),
    ),
  );
});

List<Edge> edges = List.generate(nodes.length, (index) {
  final frandom = Random();
  final srandom = Random();
  return Edge(
    from: frandom.nextInt(nodes.length) % nodes.length,
    to: srandom.nextInt(nodes.length) % nodes.length,
  );
});

class _HomeGraphPageState extends State<HomeGraphPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Граф с физикой узлов")),
      body: Center(
        child: InteractiveViewer(
          maxScale: 5,
          minScale: 0.1,
          child: ForceGraph(nodes: nodes, edges: edges, nodeRadius: 20),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: HomeGraphPage()));
}
