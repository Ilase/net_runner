import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/graph_request/graph_request_bloc.dart';

class GraphPg extends StatefulWidget {
  const GraphPg({super.key});

  @override
  State<GraphPg> createState() => _GraphPgState();
}

class _GraphPgState extends State<GraphPg> {
  final Graph graph = Graph();
  Map<String, dynamic>? selectedNodeData;

  void _showNodeInfo(Map<String, dynamic> nodeData) {
    setState(() {
      selectedNodeData = nodeData;
    });
  }

  Widget _buildNode(Map<String, dynamic> nodeData) {
    return GestureDetector(
      onTap: () => _showNodeInfo(nodeData),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(8),
        child: Text(
          nodeData['ip'],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<GraphRequestBloc>().add(GraphRequestGetNetwork(taskName: "TASK-00044"));

    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Network"),
                    IconButton(
                      onPressed: () {
                        context.read<GraphRequestBloc>().add(GraphRequestGetNetwork(taskName: "TASK-00044"));
                      },
                      icon: Icon(Icons.refresh),
                    ),
                  ],
                ),
                Expanded(
                  child: BlocConsumer<GraphRequestBloc, GraphRequestState>(
                    builder: (context, state) {
                      if (state is GraphRequestSuccess) {
                        try {
                          List<dynamic> hosts = state.graphJson["hosts"];
                          List<String> ips = hosts.map((host) => host['ip'].toString()).toList();

                          String subnetMask = ips.isNotEmpty
                              ? ips.first.split('.').sublist(0, 3).join('.') + ".0/24"
                              : "0.0.0.0/24";

                          Node subnetNode = Node.Id(subnetMask);
                          graph.addNode(subnetNode);

                          List<Node> nodes = hosts.map((host) {
                            Node node = Node.Id(host['ip']);
                            graph.addNode(node);
                            graph.addEdge(subnetNode, node);
                            return node;
                          }).toList();

                          return InteractiveViewer(
                            minScale: 0.1,
                            maxScale: 10,
                            constrained: false,
                            child: GraphView(
                              graph: graph,
                              algorithm: FruchtermanReingoldAlgorithm(
                                attractionRate: 0.01,
                                repulsionPercentage: 0.1,
                                iterations: 3000,
                              ),
                              paint: Paint()
                                ..color = Colors.blue
                                ..strokeWidth = 2
                                ..strokeCap = StrokeCap.round,
                              builder: (Node node) {
                                var nodeData = hosts.firstWhere(
                                        (h) => h['ip'] == node.key!.value,
                                    orElse: () => <String, dynamic>{}
                                ).map<String, dynamic>((key, value) => MapEntry(key.toString(), value));


                                return _buildNode(nodeData);
                              },
                            ),
                          );
                        } catch (e) {
                          ntLogger.e(e);
                        }
                      } else if (state is GraphRequestInProgress) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Center(child: Text('FAIL'));
                      }
                      return Container();
                    },
                    listener: (context, state) {},
                  ),
                ),
              ],
            ),
          ),
        ),

        if (selectedNodeData != null)
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 250,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("IP: ${selectedNodeData!['ip']}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("MAC: ${selectedNodeData!['mac']}", style: TextStyle(fontSize: 14)),
                  Text("OS: ${selectedNodeData!['os']}", style: TextStyle(fontSize: 14)),
                  Text("CPE: ${selectedNodeData!['cpe']}", style: TextStyle(fontSize: 14)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close, size: 20),
                      onPressed: () => setState(() => selectedNodeData = null),
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
