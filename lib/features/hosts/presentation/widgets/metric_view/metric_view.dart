import 'package:flutter/material.dart';

class MetricView extends StatefulWidget {
  const MetricView({super.key});

  @override
  State<MetricView> createState() => _MetricViewState();
}

class _MetricViewState extends State<MetricView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Metric view'),
    );
  }
}
