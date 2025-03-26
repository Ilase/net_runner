import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Node {
  final int id;
  Offset position;
  Offset velocity;
  final Widget child;
  bool isDragging;

  Node({
    required this.id,
    required this.position,
    required this.child,
    Offset? velocity,
    this.isDragging = false,
  }) : velocity = velocity ?? Offset.zero;
}

class Edge {
  final int fromId;
  final int toId;
  Edge({required this.fromId, required this.toId});
}

class ForceGraph extends StatefulWidget {
  final Function(int nodeId)? onNodeTap;
  final List<Node> nodes;
  final List<Edge> edges;
  final double nodeRadius;

  final double repulsion;
  final double springLength;
  final double springStiffness;
  final double damping;

  const ForceGraph({
    super.key,
    required this.nodes,
    required this.edges,
    this.nodeRadius = 20,
    this.repulsion = 5000,
    this.springLength = 100,
    this.springStiffness = 0.1,
    this.damping = 0.9,
    this.onNodeTap,
  });

  @override
  _ForceGraphState createState() => _ForceGraphState();
}

class _ForceGraphState extends State<ForceGraph>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Size areaSize = Size.zero;

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
    if (areaSize == Size.zero) return;

    List<Offset> forces =
        List.generate(widget.nodes.length, (_) => Offset.zero);

    for (int i = 0; i < widget.nodes.length; i++) {
      for (int j = i + 1; j < widget.nodes.length; j++) {
        Offset delta = widget.nodes[j].position - widget.nodes[i].position;
        double distance = delta.distance + 0.1;
        Offset direction = delta / distance;
        double force = repulsion / (distance * distance);
        forces[i] -= direction * force;
        forces[j] += direction * force;
      }
    }

    for (Edge edge in widget.edges) {
      final fromNode =
          widget.nodes.firstWhere((node) => node.id == edge.fromId);
      final toNode = widget.nodes.firstWhere((node) => node.id == edge.toId);

      Offset delta = toNode.position - fromNode.position;
      double distance = delta.distance + 0.1;
      Offset direction = delta / distance;
      double displacement = distance - springLength;
      Offset springForce = direction * (springStiffness * displacement);

      final fromIndex = widget.nodes.indexOf(fromNode);
      final toIndex = widget.nodes.indexOf(toNode);

      if (fromIndex != -1 && toIndex != -1) {
        forces[fromIndex] += springForce;
        forces[toIndex] -= springForce;
      }
    }

    for (int i = 0; i < widget.nodes.length; i++) {
      Node node = widget.nodes[i];
      if (node.isDragging) continue;

      Offset acceleration = forces[i];
      node.velocity = (node.velocity + acceleration) * damping;
      node.position += node.velocity * 0.1;

      node.position = Offset(
        node.position.dx
            .clamp(widget.nodeRadius, areaSize.width - widget.nodeRadius),
        node.position.dy
            .clamp(widget.nodeRadius, areaSize.height - widget.nodeRadius),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                  // width: widget.nodeRadius * 2,
                  // height: widget.nodeRadius * 2,
                  child: GestureDetector(
                    onTap: () => widget.onNodeTap?.call(node.id),
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
      final fromNode = nodes.firstWhere((node) => node.id == edge.fromId);
      final toNode = nodes.firstWhere((node) => node.id == edge.toId);

      canvas.drawLine(fromNode.position, toNode.position, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

///usage example
/*
* class HomeGraphPage extends StatefulWidget {
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
          child: ForceGraph(nodes: nodes, edges: edges, nodeRadius: 20), // !!!!
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: HomeGraphPage()));
}

* */
