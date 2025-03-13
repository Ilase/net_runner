import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class MetricView extends StatefulWidget {
  const MetricView({super.key});

  @override
  State<MetricView> createState() => _MetricViewState();
}

class _MetricViewState extends State<MetricView> {
  final Graph metricGraph = Graph();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Граф соотношений'),
    );
    // return Center(
    //   child: Column(
    //     children: [
    //       Text('Metric view'),
    //       Expanded(
    //         child: GraphView(
    //           graph: metricGraph,
    //           algorithm: FruchtermanReingoldAlgorithm(),
    //           builder: (Node node) {
    //             return Container(
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Colors.blue,
    //               ),
    //               child: Text('1'),
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
