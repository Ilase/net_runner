import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:xml/xml.dart';

class ScanViewerPage extends StatefulWidget {
  final XmlDocument document;
  static String route = '/scan';
  const ScanViewerPage({super.key, required this.document});

  @override
  State<ScanViewerPage> createState() => _ScanViewerPageState();
}

class _ScanViewerPageState extends State<ScanViewerPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(3, 6)
              )
            ]
          ),
        ),
      ),
    );
  }
}
