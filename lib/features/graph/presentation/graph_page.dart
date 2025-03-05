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
  Graph graph = Graph();

  @override
  void initState() {
    super.initState();
    List<Node> nodeList = List.from(widget.report.hosts);
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
