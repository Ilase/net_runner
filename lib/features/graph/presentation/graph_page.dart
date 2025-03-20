import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/networkscan/networkscan_report_serial.dart';

class GraphPage extends StatefulWidget {
  final NetworkScanReport report;

  GraphPage({required this.report});

  @override
  _NetworkGraphState createState() => _NetworkGraphState();
}

class _NetworkGraphState extends State<GraphPage> {
  final Graph graph = Graph()..isTree = true;
  final Map<String, Node> nodeMap = {};
  final Map<String, Node> subnetNodeMap = {};

  @override
  void initState() {
    super.initState();
    buildGraph();
  }

  // Функция для определения подсети по IP-адресу
  String getSubnet(String ip) {
    List<String> parts = ip.split('.');
    if (parts.length >= 2) {
      return '${parts[0]}.${parts[1]}';
    }
    return ip; // Если IP не соответствует формату, возвращаем его целиком
  }

  void buildGraph() {
    final List<NetworkScanHost> hosts = widget.report.hosts;

    // Node node1 = Node.Id("asd");
    // Node node2 = Node.Id("4512");
    // graph.addNode(node1);
    // graph.addNode(node2);
    // Создаем узлы для подсетей
    for (final host in hosts) {
      String subnet = getSubnet(host.ip);
      if (!subnetNodeMap.containsKey(subnet)) {
        Node subnetNode = Node.Id(subnet);
        subnetNodeMap[subnet] = subnetNode;
        graph.addNode(subnetNode);
      }
    }

    for (final host in hosts) {
      Node hostNode = Node.Id(host.ip);
      nodeMap[host.ip] = hostNode;
      graph.addNode(hostNode);

      String subnet = getSubnet(host.ip);
      Node subnetNode = subnetNodeMap[subnet]!;
      graph.addEdge(subnetNode, hostNode);
    }

    // for (final host in hosts) {
    //   final currentNode = nodeMap[host.ip]!;
    //
    //   for (final other in hosts) {
    //     if (host != other &&
    //         host.mac.length >= 6 &&
    //         other.mac.length >= 6 &&
    //         host.mac.substring(0, 6) == other.mac.substring(0, 6)) {
    //       graph.addEdge(currentNode, nodeMap[other.ip]!);
    //     }
    //   }
    //
    //   for (final other in hosts) {
    //     if (host != other && host.os == other.os) {
    //       graph.addEdge(currentNode, nodeMap[other.ip]!);
    //     }
    //   }
    //
    //   for (final other in hosts) {
    //     if (host != other && host.cpe == other.cpe) {
    //       graph.addEdge(currentNode, nodeMap[other.ip]!);
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.report.general_info.task_number} || ${widget.report.general_info.task_name}"),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            constrained: false,
            scaleEnabled: false,
            child: GraphView(
              graph: graph,
              paint: Paint()..color = Color.fromARGB(22, 112, 168, 186),
              algorithm: FruchtermanReingoldAlgorithm(
                attractionRate: 0.1,
                attractionPercentage: 0.1,
                repulsionRate: 0.01,
              ),
              builder: (node) => nodeWidget(node),
            ),
          ),
          infoPanel(),
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
      child: Container(
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
          children: [
            statCard("Всего просканировано", widget.report.general_info.total),
            statCard("Активны", widget.report.general_info.up),
            statCard("Неактивны", widget.report.general_info.down),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
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
                child: Column(
                  children: [
                    Text('Ноды'),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          graph.addEdge(graph.nodes.first, graph.nodes.last);
                        });
                      },
                      label: Text('Добавить'),
                      icon: Icon(Icons.connect_without_contact),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          graph.edges.clear();
                        });
                      },
                      label: Text('Убрать все'),
                      icon: Icon(Icons.connect_without_contact),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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
          child: Text("$title: $value"),
        ),
      ),
    );
  }
}
