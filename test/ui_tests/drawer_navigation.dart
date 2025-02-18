import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDrawerExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            width: isDrawerExpanded ? 300 : 100,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
              border: Border.all(width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    children: [
                      AnimatedCrossFade(
                        firstChild: Text('Page1'),
                        secondChild: Icon(Icons.ac_unit),
                        crossFadeState: isDrawerExpanded
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 500),
                      ),
                      Text('Page 2'),
                      Text('Page 3'),
                      Text('Page 4'),
                      Text('Page 5'),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isDrawerExpanded = !isDrawerExpanded;
                      });
                    },
                    icon: Icon(
                      Icons.accessible,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Placeholder())
        ],
      ),
    );
  }
}
