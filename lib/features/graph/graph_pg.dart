import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

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
                      onPressed: () {},
                      icon: Icon(Icons.refresh),
                    ),
                  ],
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
                  BoxShadow(
                      color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("IP: ${selectedNodeData!['ip']}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("MAC: ${selectedNodeData!['mac']}",
                      style: TextStyle(fontSize: 14)),
                  Text("OS: ${selectedNodeData!['os']}",
                      style: TextStyle(fontSize: 14)),
                  Text("CPE: ${selectedNodeData!['cpe']}",
                      style: TextStyle(fontSize: 14)),
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
