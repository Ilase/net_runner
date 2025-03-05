import 'package:flutter/material.dart';

class GraphPg extends StatefulWidget {
  const GraphPg({super.key});

  @override
  State<GraphPg> createState() => _GraphPgState();
}

class _GraphPgState extends State<GraphPg> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.grey,
                    offset: Offset(3, 3),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(),
                    Divider(),
                    Placeholder(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child: Stack(
              children: [
                InteractiveViewer(
                  child: Text('View'),
                ),
              ],
            ))
      ],
    );
  }
}
