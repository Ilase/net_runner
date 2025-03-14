import 'dart:collection';
import 'dart:math';

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
  double repulsionRate = 0.2;
  double attractionRate = 0.2;
  double repulsionPercentage = 1;
  double attractionPercentage = 20;

  List<String> findMostPopularCPEs(List<NetworkScanHost> hosts) {
    final cpeCount = HashMap<String, int>();
    for (var host in hosts) {
      final cpe = host.cpe.toLowerCase(); // Normalize to lowercase
      cpeCount[cpe] = (cpeCount[cpe] ?? 0) + 1;
    }
    final sortedCPEs = cpeCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedCPEs.map((entry) => entry.key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Graph graph = Graph()..isTree = false;

    List<Node> listNodes = [];
    for (final item in widget.report.hosts) {
      listNodes.add(Node.Id(item.ip));
    }

    Random random = Random();

    for (int i = 0; i < 20; ++i) {
      graph.addEdge(listNodes[widget.report.hosts.length - 1],
          listNodes[random.nextInt(widget.report.hosts.length - 1)])
        ..paint;
    }
    graph.addNodes(listNodes);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.report.general_info.task_number} || ${widget.report.general_info.task_name}"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: GraphView(
                key: ValueKey(
                    '$repulsionRate-$attractionRate-$repulsionPercentage-$attractionPercentage'),
                graph: graph,
                algorithm: FruchtermanReingoldAlgorithm(
                  iterations: 3000,
                  // repulsionPercentage: repulsionPercentage,
                  attractionPercentage: attractionPercentage,
                  attractionRate: attractionRate,
                  repulsionRate: repulsionRate,
                ),
                builder: (node) {
                  return rectangleWidget(node);
                }),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                      child: Column(
                        children: [
                          // Slider(
                          //   value: repulsionRate,
                          //   min: 1,
                          //   max: 20,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       repulsionRate = value;
                          //     });
                          //   },
                          // ),
                          // Slider(
                          //   min: 1,
                          //   max: 20,
                          //   value: attractionRate,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       attractionRate = value;
                          //     });
                          //   },
                          // ),
                          // Slider(
                          //   min: 1,
                          //   max: 100,
                          //   value: repulsionPercentage,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       repulsionPercentage = value;
                          //     });
                          //   },
                          // ),
                          // Slider(
                          //   min: 1,
                          //   max: 100,
                          //   value: attractionPercentage,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       attractionPercentage = value;
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Всего просканировано: ${widget.report.general_info.total}",
                            ),
                            Text(
                              "Активны: ${widget.report.general_info.up}",
                            ),
                            Text(
                              "Неактивны: ${widget.report.general_info.down}",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rectangleWidget(Node node) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 2)),
            child: Text('Жук'),
          ),
        ),
        secondChild: Placeholder(),
        crossFadeState: CrossFadeState.showFirst,
        duration: Duration(
          milliseconds: 200,
        ),
      ),
    );
  }
}
