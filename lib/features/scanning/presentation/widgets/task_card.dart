import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/networkscan/networkscan_report_serial.dart';
import 'dart:math';
import 'dart:async';

class GraphPage extends StatefulWidget {
  final NetworkScanReport report;

  GraphPage({required this.report});

  @override
  _NetworkGraphState createState() => _NetworkGraphState();
}

class _NetworkGraphState extends State<GraphPage> {
  final Graph graph = Graph();
  final Map<String, Node> nodeMap = {};
  final Map<String, Node> subnetNodeMap = {};
  String? currentGroupingType;
  final Random _random = Random();
  bool _isBuildingGraph = false;
  StreamController<bool> _loadingController =
      StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildUngroupedGraph();
    });
  }

  @override
  void dispose() {
    _loadingController.close();
    super.dispose();
  }

  String _getSubnet16(String ip) {
    List<String> parts = ip.split('.');
    if (parts.length >= 2) {
      return '${parts[0]}.${parts[1]}.0.0/16';
    }
    return ip;
  }

  String _getSubnet24(String ip) {
    List<String> parts = ip.split('.');
    if (parts.length >= 3) {
      return '${parts[0]}.${parts[1]}.${parts[2]}.0/24';
    }
    return ip;
  }

  Future<void> _buildUngroupedGraph() async {
    if (_isBuildingGraph) return;
    _isBuildingGraph = true;
    _loadingController.add(true);

    setState(() {
      currentGroupingType = null;
      graph.edges.clear();
      graph.nodes.clear();
      nodeMap.clear();
      subnetNodeMap.clear();
    });

    try {
      // Даем время на отрисовку очищенного состояния
      await Future.delayed(Duration(milliseconds: 50));

      // Добавляем узлы с небольшой задержкой
      for (final host in widget.report.hosts) {
        Node hostNode = Node.Id(host.ip)
          ..position = Offset(
            _random.nextDouble() * 1000,
            _random.nextDouble() * 1000,
          );

        if (!mounted) return;
        setState(() {
          nodeMap[host.ip] = hostNode;
          graph.addNode(hostNode);
        });

        await Future.delayed(Duration(milliseconds: 30));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBuildingGraph = false;
        });
      }
      _loadingController.add(false);
    }
  }

  Future<void> _buildSubnet16Graph() async {
    if (_isBuildingGraph) return;
    _isBuildingGraph = true;
    _loadingController.add(true);

    setState(() {
      currentGroupingType = 'subnet16';
      graph.edges.clear();
      graph.nodes.clear();
      nodeMap.clear();
      subnetNodeMap.clear();
    });

    try {
      // Даем время на отрисовку очищенного состояния
      await Future.delayed(Duration(milliseconds: 50));

      // Сначала создаем все подсети
      for (final host in widget.report.hosts) {
        String subnet = _getSubnet16(host.ip);
        if (!subnetNodeMap.containsKey(subnet)) {
          Node subnetNode = Node.Id(subnet)
            ..position = Offset(
              _random.nextDouble() * 1000,
              _random.nextDouble() * 1000,
            );

          if (!mounted) return;
          setState(() {
            subnetNodeMap[subnet] = subnetNode;
            graph.addNode(subnetNode);
          });
          await Future.delayed(Duration(milliseconds: 50));
        }
      }

      // Затем добавляем хосты к подсетям
      for (final host in widget.report.hosts) {
        Node hostNode = Node.Id(host.ip)
          ..position = Offset(
            _random.nextDouble() * 1000,
            _random.nextDouble() * 1000,
          );

        String subnet = _getSubnet16(host.ip);
        Node subnetNode = subnetNodeMap[subnet]!;

        if (!mounted) return;
        setState(() {
          nodeMap[host.ip] = hostNode;
          graph.addNode(hostNode);
          graph.addEdge(subnetNode, hostNode);
        });

        await Future.delayed(Duration(milliseconds: 30));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBuildingGraph = false;
        });
      }
      _loadingController.add(false);
    }
  }

  Future<void> _buildSubnet24Graph() async {
    if (_isBuildingGraph) return;
    _isBuildingGraph = true;
    _loadingController.add(true);

    setState(() {
      currentGroupingType = 'subnet24';
      graph.edges.clear();
      graph.nodes.clear();
      nodeMap.clear();
      subnetNodeMap.clear();
    });

    try {
      // Даем время на отрисовку очищенного состояния
      await Future.delayed(Duration(milliseconds: 50));

      // Сначала создаем все подсети
      for (final host in widget.report.hosts) {
        String subnet = _getSubnet24(host.ip);
        if (!subnetNodeMap.containsKey(subnet)) {
          Node subnetNode = Node.Id(subnet)
            ..position = Offset(
              _random.nextDouble() * 1000,
              _random.nextDouble() * 1000,
            );

          if (!mounted) return;
          setState(() {
            subnetNodeMap[subnet] = subnetNode;
            graph.addNode(subnetNode);
          });
          await Future.delayed(Duration(milliseconds: 50));
        }
      }

      // Затем добавляем хосты к подсетям
      for (final host in widget.report.hosts) {
        Node hostNode = Node.Id(host.ip)
          ..position = Offset(
            _random.nextDouble() * 1000,
            _random.nextDouble() * 1000,
          );

        String subnet = _getSubnet24(host.ip);
        Node subnetNode = subnetNodeMap[subnet]!;

        if (!mounted) return;
        setState(() {
          nodeMap[host.ip] = hostNode;
          graph.addNode(hostNode);
          graph.addEdge(subnetNode, hostNode);
        });

        await Future.delayed(Duration(milliseconds: 30));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBuildingGraph = false;
        });
      }
      _loadingController.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.report.general_info.task_number} || ${widget.report.general_info.task_name}"),
        leading: IconButton(
          onPressed:
              _isBuildingGraph ? null : () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            constrained: false,
            boundaryMargin: EdgeInsets.all(100),
            minScale: 0.01,
            maxScale: 5.0,
            child: GraphView(
              graph: graph,
              paint: Paint()..color = Color.fromARGB(22, 112, 168, 186),
              algorithm: FruchtermanReingoldAlgorithm(
                iterations: 1000,
                attractionRate: 1.0,
                repulsionRate: 1.0,
              ),
              builder: (node) => nodeWidget(node),
            ),
          ),
          infoPanel(),
          StreamBuilder<bool>(
            stream: _loadingController.stream,
            initialData: false,
            builder: (context, snapshot) {
              return Visibility(
                visible: snapshot.data ?? false,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Построение графа...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget nodeWidget(Node node) {
    String nodeId = node.key?.value ?? '';
    bool isSubnet = subnetNodeMap.containsValue(node);

    return GestureDetector(
      onTap: () {
        print("Clicked on node $nodeId");
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSubnet ? Colors.green : Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 5,
              color: Colors.black26,
            ),
          ],
        ),
        child: Text(
          nodeId,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget infoPanel() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            statCard("Всего просканировано", widget.report.general_info.total),
            statCard("Активны", widget.report.general_info.up),
            statCard("Неактивны", widget.report.general_info.down),
            SizedBox(height: 16),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(3, 3),
                    blurRadius: 15,
                    color: Colors.grey,
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Группировка узлов',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildGroupingButton(
                      icon: Icons.view_agenda_outlined,
                      label: 'Без группировки',
                      isActive: currentGroupingType == null,
                      onPressed: _buildUngroupedGraph,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    _buildGroupingButton(
                      icon: Icons.account_tree_outlined,
                      label: 'Группировка /16 (X.X.0.0)',
                      isActive: currentGroupingType == 'subnet16',
                      onPressed: _buildSubnet16Graph,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    _buildGroupingButton(
                      icon: Icons.account_tree_outlined,
                      label: 'Группировка /24 (X.X.X.0)',
                      isActive: currentGroupingType == 'subnet24',
                      onPressed: _buildSubnet24Graph,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupingButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: _isBuildingGraph ? null : onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 40),
      ),
    );
  }

  Widget statCard(String title, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 3),
              blurRadius: 15,
              color: Colors.grey,
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("$title: $value", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
